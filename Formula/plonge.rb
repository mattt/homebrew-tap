class Plonge < Formula
  desc "Find and delete the caches that developer tools leave on disk"
  homepage "https://github.com/mattt/plonge"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattt/plonge/releases/download/v0.2.1/plonge_0.2.1_darwin_arm64.tar.gz"
      sha256 "768486e6c6fd3f9ff3ccac4b39302c499a88ca9b496b66e254a5749895b528a8"
    end
    on_intel do
      url "https://github.com/mattt/plonge/releases/download/v0.2.1/plonge_0.2.1_darwin_amd64.tar.gz"
      sha256 "36754cce8ad05a3a37e1d12ba9b55d97961c14f2c4e296456de731ee62c8e8bc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mattt/plonge/releases/download/v0.2.1/plonge_0.2.1_linux_arm64.tar.gz"
      sha256 "5da63fd52c5d2b602887f6df1cf37fcea90e234e6b9026cb039b84b816e85650"
    end
    on_intel do
      url "https://github.com/mattt/plonge/releases/download/v0.2.1/plonge_0.2.1_linux_amd64.tar.gz"
      sha256 "a170bb0e3cf3c1383935ac68feb8191f0ac933225b4aa3b8da38f44586afa3f1"
    end
  end

  def install
    bin.install "plonge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plonge --version")
  end
end
