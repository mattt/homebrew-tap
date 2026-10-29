class Things < Formula
  desc "CLI and MCP server for Things 3"
  homepage "https://github.com/mattt/things-cli"
  license "MIT"

  depends_on :macos

  on_macos do
    depends_on macos: :monterey

    on_arm do
      url "https://github.com/mattt/things-cli/releases/download/v0.2.1/things_0.2.1_darwin_arm64.tar.gz"
      sha256 "139dc63aabc05d9c3b97b96feac7aaec30e3b7809f54375ba971ec352adfc284"
    end
    on_intel do
      url "https://github.com/mattt/things-cli/releases/download/v0.2.1/things_0.2.1_darwin_amd64.tar.gz"
      sha256 "8ed4c7ef0597c146307588f1ab97e6cc18ddbd1d500180c47b3f16112cc38fe8"
    end
  end

  def install
    bin.install "things"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/things version")
  end
end
