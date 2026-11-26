class Plonge < Formula
  desc "Find and delete the caches that developer tools leave on disk"
  homepage "https://github.com/mattt/plonge"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattt/plonge/releases/download/v0.5.2/plonge_0.5.2_darwin_arm64.tar.gz"
      sha256 "4c58c35fb6d494207a3a325483467e3ba484214180db7b502a8e95997197d4a9"
    end
    on_intel do
      url "https://github.com/mattt/plonge/releases/download/v0.5.2/plonge_0.5.2_darwin_amd64.tar.gz"
      sha256 "5da79b825ebc7fcb7b2e7e72a6f03e48983b93f1f9ad2d9f552b9c03c8eefaf5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mattt/plonge/releases/download/v0.5.2/plonge_0.5.2_linux_arm64.tar.gz"
      sha256 "6552cd7f78a06358f549ad15903aee10fdbb3a367cb023f2db45ea698be4a518"
    end
    on_intel do
      url "https://github.com/mattt/plonge/releases/download/v0.5.2/plonge_0.5.2_linux_amd64.tar.gz"
      sha256 "f2bf7e4977685a261afb7948278d4b05679f5cee4e2e1773246d0d6c3ce81e05"
    end
  end

  def install
    bin.install "plonge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plonge --version")
  end
end
