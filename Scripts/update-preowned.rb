#!/usr/bin/env ruby
# frozen_string_literal: true

# Update the binary formula only after a complete, verified stable release.
require_relative "binary_formula"

REPO = "mattt/preowned"

TEMPLATE = <<'EOS'
class Preowned < Formula
  desc "OpenAI-compatible API for the models built into macOS"
  homepage "https://github.com/mattt/preowned"
  %<darwin_arm64>s
  license "MIT"

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
EOS

render = lambda do |version, archives, checksums|
  name = archives.fetch("darwin_arm64")
  format(TEMPLATE, darwin_arm64: BinaryFormula.asset_stanza(REPO, version, name, checksums[name], "  "))
end

BinaryFormula.update(
  repo: REPO,
  name: "preowned",
  previous: %r{/download/v(\d+\.\d+\.\d+)/},
  first_release_ok: true,
  archives: ->(_tag, version) { { "darwin_arm64" => "preowned_#{version}_darwin_arm64.tar.gz" } },
  manifest: ->(_tag, version) { "preowned_#{version}_checksums.txt" },
  waiting: "the archive",
  exactly: "the archive",
  render: render
)
