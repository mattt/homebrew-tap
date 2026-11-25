class Things < Formula
  desc "CLI and MCP server for Things 3"
  homepage "https://github.com/mattt/things-cli"
  url "https://github.com/mattt/things-cli/releases/download/v0.3.1/things_0.3.1_darwin_arm64.tar.gz"
  sha256 "f03452e1bcc9dc635208b01e4e9c87c348e5d2a39693c06cbe1c36d955a16920"
  license "MIT"

  depends_on :macos

  on_macos do
    depends_on macos: :monterey

    on_intel do
      url "https://github.com/mattt/things-cli/releases/download/v0.3.1/things_0.3.1_darwin_amd64.tar.gz"
      sha256 "d3d9f84ad5ab9f7ca3aeb914fe13a6e40d73d95ff4615f6a6bf30cad9ff5cbad"
    end
  end

  def install
    bin.install "things"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/things version")
  end
end
