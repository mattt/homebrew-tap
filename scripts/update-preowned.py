#!/usr/bin/env python3
"""Update the binary formula only after a complete, verified stable release."""
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile

TARGETS = ("darwin_arm64",)
REPO = "mattt/preowned"


def gh(*args):
    return subprocess.check_output(["gh", *args, "--repo", REPO], text=True)


def update():
    try:
        release = json.loads(gh("release", "view", "--json", "tagName,isDraft,isPrerelease,assets"))
    except subprocess.CalledProcessError:
        if gh("release", "list", "--limit", "1").strip():
            raise
        print(f"{REPO}: waiting for the first release")
        return
    tag = release["tagName"]
    if release["isDraft"] or release["isPrerelease"] or not re.fullmatch(r"v\d+\.\d+\.\d+", tag):
        raise ValueError("Expected a stable vMAJOR.MINOR.PATCH release")
    version = tag[1:]
    formula_path = Path("Formula/preowned.rb")
    current = formula_path.read_text() if formula_path.exists() else ""
    previous = re.search(r"/download/v(\d+\.\d+\.\d+)/", current)
    if previous and tuple(map(int, previous[1].split("."))) > tuple(map(int, version.split("."))):
        raise ValueError("Refusing to downgrade the formula")
    names = {a["name"] for a in release["assets"]}
    manifest = f"preowned_{version}_checksums.txt"
    archives = {target: f"preowned_{version}_{target}.tar.gz" for target in TARGETS}
    if not {manifest, *archives.values()} <= names:
        print(f"{tag}: waiting for the archive and {manifest}")
        return
    with tempfile.TemporaryDirectory() as tmp:
        gh("release", "download", tag, "--pattern", manifest, "--dir", tmp)
        checksums = {}
        for line in (Path(tmp) / manifest).read_text().splitlines():
            match = re.fullmatch(r"([0-9a-f]{64})  ([A-Za-z0-9._-]+)", line)
            if not match or match[2] in checksums:
                raise ValueError("Malformed or duplicate checksum entry")
            checksums[match[2]] = match[1]
        if set(checksums) != set(archives.values()):
            raise ValueError("Checksum manifest must describe exactly the archive")
        formula = render(version, archives, checksums)
        if formula == current:
            print(f"{tag}: formula already current")
            return
        for name in archives.values():
            gh("release", "download", tag, "--pattern", name, "--dir", tmp)
            actual = hashlib.sha256((Path(tmp) / name).read_bytes()).hexdigest()
            if actual != checksums[name]:
                raise ValueError(f"Checksum mismatch for {name}")
        formula_path.write_text(formula)
    print(f"Updated preowned to {tag}")
    if output := os.environ.get("GITHUB_OUTPUT"):
        with open(output, "a") as handle:
            handle.write("changed=true\n")
            handle.write(f"version={version}\n")


def render(version, archives, checksums):
    name = archives["darwin_arm64"]
    return ('''class Preowned < Formula
  desc "OpenAI-compatible API for the models built into macOS"
  homepage "https://github.com/mattt/preowned"
''' + f'''  url "https://github.com/{REPO}/releases/download/v{version}/{name}"
  sha256 "{checksums[name]}"
''' + '''  license "MIT"

  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    bin.install "preowned"
  end

  def caveats
    <<~EOS
      Chat and images need Apple Intelligence turned on in System Settings.
      Run `preowned inventory` to see which models work on this Mac.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/preowned --version")
    assert_match "inventory", shell_output("#{bin}/preowned --help")
  end
end
''')


if __name__ == "__main__":
    update()
