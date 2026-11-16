class Plonge < Formula
  desc "Find and delete the caches that developer tools leave on disk"
  homepage "https://github.com/mattt/plonge"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattt/plonge/releases/download/v0.3.0/plonge_0.3.0_darwin_arm64.tar.gz"
      sha256 "3d293d934067ae3712e5fbec1d864a9900a44f34ababcabec847784ec7d95e60"
    end
    on_intel do
      url "https://github.com/mattt/plonge/releases/download/v0.3.0/plonge_0.3.0_darwin_amd64.tar.gz"
      sha256 "2afdf36ed624cbdf0a2583bc014f738afa214166067d570b21743214b3f58acd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mattt/plonge/releases/download/v0.3.0/plonge_0.3.0_linux_arm64.tar.gz"
      sha256 "394b8e263b11e8d0b553c4ba4e67642d311f6b9ea56809088da0bd63ab6e7548"
    end
    on_intel do
      url "https://github.com/mattt/plonge/releases/download/v0.3.0/plonge_0.3.0_linux_amd64.tar.gz"
      sha256 "04cb9d6692389a9779deca7747216fbdc0a6ee1fd304147155f01a9c7c945f41"
    end
  end

  def install
    bin.install "plonge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plonge --version")
  end
end
