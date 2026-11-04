class Things < Formula
  desc "CLI and MCP server for Things 3"
  homepage "https://github.com/mattt/things-cli"
  license "MIT"

  depends_on :macos

  on_macos do
    depends_on macos: :monterey

    on_arm do
      url "https://github.com/mattt/things-cli/releases/download/v0.2.2/things_0.2.2_darwin_arm64.tar.gz"
      sha256 "11d9c37f0e104a9a3100eeaf20b36d5e1fd8106be1e5ffd97cbefc431d8063e2"
    end
    on_intel do
      url "https://github.com/mattt/things-cli/releases/download/v0.2.2/things_0.2.2_darwin_amd64.tar.gz"
      sha256 "f50f03346407c3e5ee52d8cc569901f271997aee3bbd56e199ec10c7d0c431ef"
    end
  end

  def install
    bin.install "things"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/things version")
  end
end
