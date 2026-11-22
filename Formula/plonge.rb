class Plonge < Formula
  desc "Find and delete the caches that developer tools leave on disk"
  homepage "https://github.com/mattt/plonge"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattt/plonge/releases/download/v0.5.0/plonge_0.5.0_darwin_arm64.tar.gz"
      sha256 "4cc8d560f6999f0f984488109a96d86ab2475c483b01ffb2da06304453c48c9b"
    end
    on_intel do
      url "https://github.com/mattt/plonge/releases/download/v0.5.0/plonge_0.5.0_darwin_amd64.tar.gz"
      sha256 "73a40fd1bddf9c817112ec00c9fa6290e4f68222493333a03b92f17ab1e11da2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mattt/plonge/releases/download/v0.5.0/plonge_0.5.0_linux_arm64.tar.gz"
      sha256 "c7135b6b4ecb55320f3ff443e103a6e494ac0a4247f2136618bce73aad50fc32"
    end
    on_intel do
      url "https://github.com/mattt/plonge/releases/download/v0.5.0/plonge_0.5.0_linux_amd64.tar.gz"
      sha256 "6e1a0b355ff539522daec9e99d66f2b416becbd9b64c53825e861fb50436919f"
    end
  end

  def install
    bin.install "plonge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plonge --version")
  end
end
