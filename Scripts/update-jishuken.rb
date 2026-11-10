#!/usr/bin/env ruby
# frozen_string_literal: true

# Update the binary formula only after a complete, verified stable release.
require_relative "release"

REPO = "mattt/jishuken"
TARGETS = %w[
  aarch64-apple-darwin
  x86_64-apple-darwin
  aarch64-unknown-linux-musl
  x86_64-unknown-linux-musl
].freeze

TEMPLATE = <<'EOS'
class Jishuken < Formula
  desc "Self-verifying memory for agents"
  homepage "https://github.com/mattt/jishuken"
  license "MIT"
%<revision>s
  depends_on arch: [:arm64, :x86_64]

  on_macos do
    depends_on macos: :big_sur

    on_arm do
      %<aarch64_apple_darwin>s
    end
    on_intel do
      %<x86_64_apple_darwin>s
    end
  end

  on_linux do
    on_arm do
      %<aarch64_unknown_linux_musl>s
    end
    on_intel do
      %<x86_64_unknown_linux_musl>s
    end
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
EOS

render = lambda do |version, archives, checksums|
  stanzas = archives.to_h do |target, name|
    [target.tr("-", "_").to_sym, Release.asset_stanza(REPO, version, name, checksums[name], "      ")]
  end
  # Upgrade users of the original 0.1.0 source formula to the binary package.
  revision = version == "0.1.0" ? "  revision 1\n" : ""
  format(TEMPLATE, revision: revision, **stanzas)
end

Release.update(
  repo: REPO,
  path: "Formula/jishuken.rb",
  previous: %r{(?:version "|/tags/v|/download/v)(\d+\.\d+\.\d+)},
  archives: ->(version) { TARGETS.to_h { |t| [t, "jishuken-v#{version}-#{t}.tar.gz"] } },
  manifest: ->(_version) { "SHA256SUMS" },
  render: render,
  first_release_ok: false
)
