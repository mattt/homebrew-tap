class Plonge < Formula
  desc "Find and delete the caches that developer tools leave on disk"
  homepage "https://github.com/mattt/plonge"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattt/plonge/releases/download/v0.5.1/plonge_0.5.1_darwin_arm64.tar.gz"
      sha256 "b38132423d64b5f7d92f0716a02af28b1c68fa08547e5236196aa3d3df5b0f09"
    end
    on_intel do
      url "https://github.com/mattt/plonge/releases/download/v0.5.1/plonge_0.5.1_darwin_amd64.tar.gz"
      sha256 "d267e0a31511683faffa5de451cd182b56faf89c9e056f6e52e813081c47b47b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mattt/plonge/releases/download/v0.5.1/plonge_0.5.1_linux_arm64.tar.gz"
      sha256 "5df575bd152253e1d28c9a4372f3607d089b517856dac4c8df12798816673153"
    end
    on_intel do
      url "https://github.com/mattt/plonge/releases/download/v0.5.1/plonge_0.5.1_linux_amd64.tar.gz"
      sha256 "1e0dc6b3ca19da09065e7ff029c98df30bc9740b636459dbc55c2514aa0b19c0"
    end
  end

  def install
    bin.install "plonge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plonge --version")
  end
end
