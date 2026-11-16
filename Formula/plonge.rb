class Plonge < Formula
  desc "Find and delete the caches that developer tools leave on disk"
  homepage "https://github.com/mattt/plonge"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattt/plonge/releases/download/v0.2.0/plonge_0.2.0_darwin_arm64.tar.gz"
      sha256 "f80dd8c0495be504050638e44e63750619929633fec4e424a098cb260c1406aa"
    end
    on_intel do
      url "https://github.com/mattt/plonge/releases/download/v0.2.0/plonge_0.2.0_darwin_amd64.tar.gz"
      sha256 "a0f3451776c18a8b440c9c508a8bf128450376e13b8221240acf5ec9ff502de3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mattt/plonge/releases/download/v0.2.0/plonge_0.2.0_linux_arm64.tar.gz"
      sha256 "b6459cc4656ebaaf4d8a4a19482b13ca259852a38c7c691e970531857d7ba867"
    end
    on_intel do
      url "https://github.com/mattt/plonge/releases/download/v0.2.0/plonge_0.2.0_linux_amd64.tar.gz"
      sha256 "e2f9b2038e98d6e7ded1af5d37946f2562ffae507c0ea88be593884c9e2b7edb"
    end
  end

  def install
    bin.install "plonge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plonge --version")
  end
end
