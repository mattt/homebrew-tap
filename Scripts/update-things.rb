#!/usr/bin/env ruby
# frozen_string_literal: true

# Update the binary formula only after a complete, verified stable release.
require_relative "release"

repo = "mattt/things-cli"

template = <<~'EOS'
  class Things < Formula
    desc "CLI and MCP server for Things 3"
    homepage "https://github.com/mattt/things-cli"
    %<darwin_arm64>s
    license "MIT"

    depends_on :macos

    on_macos do
      depends_on macos: :monterey

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
    pad = if target == "darwin_arm64"
      "  "
    else
      "      "
    end
    [target.to_sym, Release.asset_stanza(repo, version, name, checksums[name], pad)]
  end
  format(template, **stanzas)
end

Release.update(
  repo:     repo,
  path:     "Formula/things.rb",
  previous: %r{/download/v(\d+\.\d+\.\d+)/},
  archives: ->(version) { %w[darwin_arm64 darwin_amd64].to_h { |t| [t, "things_#{version}_#{t}.tar.gz"] } },
  manifest: ->(version) { "things_#{version}_checksums.txt" },
  render:   render,
)
