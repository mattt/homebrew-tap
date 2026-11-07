#!/usr/bin/env python3
"""Update the rePossess cask only after a complete, verified stable release."""
import hashlib
import os
from pathlib import Path
import re
import subprocess
import tempfile
import json

REPO = "mattt/rePossess"
CASK = Path("Casks/repossess.rb")


def gh(*args):
    return subprocess.check_output(["gh", *args, "--repo", REPO], text=True)


def update():
    release = json.loads(gh("release", "view", "--json", "tagName,isDraft,isPrerelease,assets"))
    tag = release["tagName"]
    if release["isDraft"] or release["isPrerelease"] or not re.fullmatch(r"\d+\.\d+\.\d+", tag):
        raise ValueError("Expected a stable MAJOR.MINOR.PATCH release")
    current = CASK.read_text()
    previous = re.search(r'^  version "(\d+\.\d+\.\d+)"$', current, re.MULTILINE)
    if not previous:
        raise ValueError("The cask has no version line")
    if tuple(map(int, previous[1].split("."))) > tuple(map(int, tag.split("."))):
        raise ValueError("Refusing to downgrade the cask")
    if previous[1] == tag:
        print(f"{tag}: cask already current")
        return
    archive = f"rePossess-{tag}.zip"
    checksum = f"{archive}.sha256"
    names = {asset["name"] for asset in release["assets"]}
    if not {archive, checksum} <= names:
        print(f"{tag}: waiting for {archive} and {checksum}")
        return
    with tempfile.TemporaryDirectory() as tmp:
        gh("release", "download", tag, "--pattern", checksum, "--dir", tmp)
        match = re.fullmatch(r"([0-9a-f]{64})  " + re.escape(archive) + r"\n?", (Path(tmp) / checksum).read_text())
        if not match:
            raise ValueError(f"Malformed {checksum}")
        gh("release", "download", tag, "--pattern", archive, "--dir", tmp)
        actual = hashlib.sha256((Path(tmp) / archive).read_bytes()).hexdigest()
        if actual != match[1]:
            raise ValueError(f"Checksum mismatch for {archive}")
    updated = re.sub(r'^  version ".*"$', f'  version "{tag}"', current, count=1, flags=re.MULTILINE)
    updated = re.sub(r'^  sha256 ".*"$', f'  sha256 "{actual}"', updated, count=1, flags=re.MULTILINE)
    CASK.write_text(updated)
    print(f"Updated repossess to {tag}")
    if output := os.environ.get("GITHUB_OUTPUT"):
        with open(output, "a") as handle:
            handle.write("changed=true\n")
            handle.write(f"version={tag}\n")


if __name__ == "__main__":
    update()
