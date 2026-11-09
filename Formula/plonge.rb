class Plonge < Formula
  desc "Find and delete the caches that developer tools leave on disk"
  homepage "https://github.com/mattt/plonge"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattt/plonge/releases/download/v0.1.1/plonge_0.1.1_darwin_arm64.tar.gz"
      sha256 "aed8c972a7c4ad6e800aa621af936b0cd0af1967eaa4679da38887534516776e"
    end
    on_intel do
      url "https://github.com/mattt/plonge/releases/download/v0.1.1/plonge_0.1.1_darwin_amd64.tar.gz"
      sha256 "18420d4b6760e3ca95233bfa26fb42a03ce30c687b85cd9ce6421259fdf61078"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mattt/plonge/releases/download/v0.1.1/plonge_0.1.1_linux_arm64.tar.gz"
      sha256 "ae0ffef6e4033713d35e75e9dfec8f0bb904b7b5655676ed9049b858e78d0a9e"
    end
    on_intel do
      url "https://github.com/mattt/plonge/releases/download/v0.1.1/plonge_0.1.1_linux_amd64.tar.gz"
      sha256 "691325e512a42085cb424c79f02b52375dc229d3b9ba6eb703aa74e2037d687d"
    end
  end

  def install
    bin.install "plonge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plonge --version")
  end
end
