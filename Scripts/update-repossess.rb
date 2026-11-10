#!/usr/bin/env ruby
# frozen_string_literal: true

# Update the rePossess cask only after a complete, verified stable release.
require_relative "release"

TEMPLATE = <<'EOS'
cask "repossess" do
  version "%<version>s"
  sha256 "%<sha256>s"

  url "https://github.com/mattt/rePossess/releases/download/#{version}/rePossess-#{version}.zip"
  name "rePossess"
  desc "Menu bar app that connects a reMarkable tablet to MCP clients"
  homepage "https://github.com/mattt/rePossess"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :golden_gate

  app "rePossess.app"
  binary "#{appdir}/rePossess.app/Contents/MacOS/repossess"

  zap trash: [
    "~/Library/Application Support/rePossess",
    "~/Library/Preferences/co.dododo.repossess.plist",
  ]
end
EOS

render = lambda do |version, archives, checksums|
  format(TEMPLATE, version: version, sha256: checksums.fetch(archives.fetch("zip")))
end

Release.update(
  repo: "mattt/rePossess",
  path: "Casks/repossess.rb",
  prefix: "",
  previous: /^  version "(\d+\.\d+\.\d+)"$/,
  archives: ->(version) { { "zip" => "rePossess-#{version}.zip" } },
  manifest: ->(version) { "rePossess-#{version}.zip.sha256" },
  render: render,
  first_release_ok: false
)
