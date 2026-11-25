#!/usr/bin/env ruby
# frozen_string_literal: true

# Update the binary formula only after a complete, verified stable release.
require_relative "release"

repo = "mattt/emcee"
targets = %w[Darwin_arm64 Darwin_x86_64 Linux_arm64 Linux_x86_64].freeze

template = <<~EOS
  class Emcee < Formula
    desc "MCP generator for OpenAPIs"
    homepage "https://emcee.sh"
    license "MIT"

    on_macos do
      on_arm do
        %<Darwin_arm64>s
      end
      on_intel do
        %<Darwin_x86_64>s
      end
    end

    on_linux do
      on_arm do
        %<Linux_arm64>s
      end
      on_intel do
        %<Linux_x86_64>s
      end
    end

    def install
      bin.install "emcee"
    end

    test do
      system bin/"emcee", "--version"
    end
  end
EOS

render = lambda do |version, archives, checksums|
  stanzas = archives.to_h do |target, name|
    [target.to_sym, Release.asset_stanza(repo, version, name, checksums[name], "      ")]
  end
  format(template, **stanzas)
end

Release.update(
  repo:     repo,
  path:     "Formula/emcee.rb",
  previous: %r{/download/v(\d+\.\d+\.\d+)/},
  archives: ->(_version) { targets.to_h { |t| [t, "emcee_#{t}.tar.gz"] } },
  manifest: ->(version) { "emcee_#{version}_checksums.txt" },
  unused:   ["emcee_Linux_i386.tar.gz"],
  render:   render,
)
