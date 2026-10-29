class Things < Formula
  desc "CLI and MCP server for Things 3"
  homepage "https://github.com/mattt/things-cli"
  license "MIT"

  depends_on :macos

  on_macos do
    depends_on macos: :monterey

    on_arm do
      url "https://github.com/mattt/things-cli/releases/download/v0.2.0/things_0.2.0_darwin_arm64.tar.gz"
      sha256 "bafa246484e303ff2d6e0b5cef415446d470b5a89f424ac7086d252ad22214c6"
    end
    on_intel do
      url "https://github.com/mattt/things-cli/releases/download/v0.2.0/things_0.2.0_darwin_amd64.tar.gz"
      sha256 "950a4a9963a8f7264d67a623efd2ce4927322ec164f2469271522225f6a22454"
    end
  end

  def install
    bin.install "things"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/things version")
  end
end
