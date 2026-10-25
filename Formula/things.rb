class Things < Formula
  desc "CLI and MCP server for Things 3"
  homepage "https://github.com/mattt/things-cli"
  license "MIT"

  depends_on :macos

  on_macos do
    depends_on macos: :monterey

    on_arm do
      url "https://github.com/mattt/things-cli/releases/download/v0.1.0/things_0.1.0_darwin_arm64.tar.gz"
      sha256 "cb908a7099edf8041b5282401e0fdbee7548f662f8471e13d90d824f8d3c43c1"
    end
    on_intel do
      url "https://github.com/mattt/things-cli/releases/download/v0.1.0/things_0.1.0_darwin_amd64.tar.gz"
      sha256 "68f6187802de8b063727223d34e94a4f87ca3eb16b6c53f5cb46dd49f876cf5b"
    end
  end

  def install
    bin.install "things"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/things version")
  end
end
