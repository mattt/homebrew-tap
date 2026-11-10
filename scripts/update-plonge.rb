#!/usr/bin/env ruby
# frozen_string_literal: true

# Update the binary formula only after a complete, verified stable release.
require_relative "binary_formula"

REPO = "mattt/plonge"
TARGETS = %w[darwin_arm64 darwin_amd64 linux_arm64 linux_amd64].freeze

TEMPLATE = <<'EOS'
class Plonge < Formula
  desc "Find and delete the caches that developer tools leave on disk"
  homepage "https://github.com/mattt/plonge"
  license "MIT"

  on_macos do
    on_arm do
      %<darwin_arm64>s
    end
    on_intel do
      %<darwin_amd64>s
    end
  end

  on_linux do
    on_arm do
      %<linux_arm64>s
    end
    on_intel do
      %<linux_amd64>s
    end
  end

  def install
    bin.install "plonge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plonge --version")
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
  name: "plonge",
  previous: %r{/download/v(\d+\.\d+\.\d+)/},
  first_release_ok: true,
  archives: ->(_tag, version) { TARGETS.to_h { |t| [t, "plonge_#{version}_#{t}.tar.gz"] } },
  manifest: ->(_tag, version) { "plonge_#{version}_checksums.txt" },
  waiting: "all four archives",
  exactly: "the four archives",
  render: render
)
