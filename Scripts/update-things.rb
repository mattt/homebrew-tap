#!/usr/bin/env ruby
# frozen_string_literal: true

# Update the binary formula only after a complete, verified stable release.
require_relative "binary_formula"

REPO = "mattt/things-cli"

TEMPLATE = <<'EOS'
class Things < Formula
  desc "CLI and MCP server for Things 3"
  homepage "https://github.com/mattt/things-cli"
  license "MIT"

  depends_on :macos

  on_macos do
    depends_on macos: :monterey

    on_arm do
      %<darwin_arm64>s
    end
    on_intel do
      %<darwin_amd64>s
    end
  end

  def install
    bin.install "things"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/things version")
  end
end
EOS

render = lambda do |version, archives, checksums|
  stanzas = archives.to_h do |target, name|
    [target.to_sym, BinaryFormula.asset_stanza(REPO, version, name, checksums[name], "      ")]
  end
  format(TEMPLATE, **stanzas)
end

BinaryFormula.update(
  repo: REPO,
  name: "things",
  previous: %r{/download/v(\d+\.\d+\.\d+)/},
  first_release_ok: true,
  archives: ->(_tag, version) { %w[darwin_arm64 darwin_amd64].to_h { |t| [t, "things_#{version}_#{t}.tar.gz"] } },
  manifest: ->(_tag, version) { "things_#{version}_checksums.txt" },
  waiting: "both archives",
  exactly: "the two archives",
  render: render
)
