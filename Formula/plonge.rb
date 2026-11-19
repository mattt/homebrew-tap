class Plonge < Formula
  desc "Find and delete the caches that developer tools leave on disk"
  homepage "https://github.com/mattt/plonge"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattt/plonge/releases/download/v0.4.0/plonge_0.4.0_darwin_arm64.tar.gz"
      sha256 "811ecfce83029074b140a2bbf1429dc31aebdcd92c7dd4b016b6672f6145cc12"
    end
    on_intel do
      url "https://github.com/mattt/plonge/releases/download/v0.4.0/plonge_0.4.0_darwin_amd64.tar.gz"
      sha256 "3d217170825790e17b2a869fcca3fb657c8d9afba9ac7ac8693c1fb8bf8d8be8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mattt/plonge/releases/download/v0.4.0/plonge_0.4.0_linux_arm64.tar.gz"
      sha256 "7d5a7f187ff8f75aac48b1b0b10556f8eb8fb9158c35af006e38cb72a6ea2a2a"
    end
    on_intel do
      url "https://github.com/mattt/plonge/releases/download/v0.4.0/plonge_0.4.0_linux_amd64.tar.gz"
      sha256 "f7731e6c6b1221ae9b2c91e005eb0d253813e9ea9459f3a649b4c07fd7461272"
    end
  end

  def install
    bin.install "plonge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plonge --version")
  end
end
