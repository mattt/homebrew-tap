#!/usr/bin/env python3
"""Update the binary formula only after a complete, verified stable release."""
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile

TARGETS = (
    "aarch64-apple-darwin",
    "x86_64-apple-darwin",
    "aarch64-unknown-linux-musl",
    "x86_64-unknown-linux-musl",
)
REPO = "mattt/jishuken"


def gh(*args):
    return subprocess.check_output(["gh", *args, "--repo", REPO], text=True)


def update():
    release = json.loads(gh("release", "view", "--json", "tagName,isDraft,isPrerelease,assets"))
    tag = release["tagName"]
    if release["isDraft"] or release["isPrerelease"] or not re.fullmatch(r"v\d+\.\d+\.\d+", tag):
        raise ValueError("Expected a stable vMAJOR.MINOR.PATCH release")
    version = tag[1:]
    formula_path = Path("Formula/jishuken.rb")
    current = formula_path.read_text()
    previous = re.search(r'(?:version "|/tags/v)(\d+\.\d+\.\d+)', current)
    if previous and tuple(map(int, previous[1].split("."))) > tuple(map(int, version.split("."))):
        raise ValueError("Refusing to downgrade the formula")
    names = {a["name"] for a in release["assets"]}
    archives = {target: f"jishuken-{tag}-{target}.tar.gz" for target in TARGETS}
    if not {"SHA256SUMS", *archives.values()} <= names:
        print(f"{tag}: waiting for all four archives and SHA256SUMS")
        return
    with tempfile.TemporaryDirectory() as tmp:
        gh("release", "download", tag, "--pattern", "SHA256SUMS", "--dir", tmp)
        checksums = {}
        for line in (Path(tmp) / "SHA256SUMS").read_text().splitlines():
            match = re.fullmatch(r"([0-9a-f]{64})  ([A-Za-z0-9._-]+)", line)
            if not match or match[2] in checksums:
                raise ValueError("Malformed or duplicate checksum entry")
            checksums[match[2]] = match[1]
        if set(checksums) != set(archives.values()):
            raise ValueError("Checksum manifest must describe exactly the four archives")
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
    print(f"Updated jishuken to {tag}")
    if output := os.environ.get("GITHUB_OUTPUT"):
        with open(output, "a") as handle:
            handle.write("changed=true\n")
            handle.write(f"version={version}\n")


def render(version, archives, checksums):
    def asset(target, indent):
        name = archives[target]
        pad = " " * indent
        return (f'{pad}url "https://github.com/{REPO}/releases/download/v{version}/{name}"\n'
                f'{pad}sha256 "{checksums[name]}"\n')

    # Upgrade users of the original 0.1.0 source formula to the binary package.
    revision = "  revision 1\n" if version == "0.1.0" else ""
    return (f'''class Jishuken < Formula
  desc "Self-verifying memory for agents"
  homepage "https://github.com/mattt/jishuken"
  version "{version}"
  license "MIT"
{revision}
  depends_on arch: [:arm64, :x86_64]

  on_macos do
    depends_on macos: :big_sur

    on_arm do
''' + asset("aarch64-apple-darwin", 6) + '''    end
    on_intel do
''' + asset("x86_64-apple-darwin", 6) + '''    end
  end

  on_linux do
    on_arm do
''' + asset("aarch64-unknown-linux-musl", 6) + '''    end
    on_intel do
''' + asset("x86_64-unknown-linux-musl", 6) + '''    end
  end

  def install
    bin.install "ken"
  end

  def caveats
    <<~EOS
      The command is named ken.
      Install Deno to use generator scripts and source handlers:
        brew install deno
    EOS
  end

  test do
    system bin/"ken", "init"
    system bin/"ken", "add", "release.owner", "ryu", "--half-life", "P3D"
    fact = JSON.parse(shell_output("#{bin}/ken recall release.owner --json"))
    assert_equal "ryu", fact.fetch("value")
  end
end
''')


if __name__ == "__main__":
    update()
