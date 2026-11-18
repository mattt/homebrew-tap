class Things < Formula
  desc "CLI and MCP server for Things 3"
  homepage "https://github.com/mattt/things-cli"
  license "MIT"

  depends_on :macos

  on_macos do
    depends_on macos: :monterey

    on_arm do
      url "https://github.com/mattt/things-cli/releases/download/v0.3.0/things_0.3.0_darwin_arm64.tar.gz"
      sha256 "04e1340476aab0de7ebbddd56c6b303ec4114c098df415b2d59b7914229165db"
    end
    on_intel do
      url "https://github.com/mattt/things-cli/releases/download/v0.3.0/things_0.3.0_darwin_amd64.tar.gz"
      sha256 "edd70d655c35afc9759adeb3518a617aad99fe6a2af2e69265a9506d90630b5a"
    end
  end

  def install
    bin.install "things"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/things version")
  end
end
