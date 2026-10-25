class Preowned < Formula
  desc "OpenAI-compatible API for the models built into macOS"
  homepage "https://github.com/mattt/preowned"
  url "https://github.com/mattt/preowned/releases/download/v0.1.0/preowned_0.1.0_darwin_arm64.tar.gz"
  sha256 "2a0fd7f1e9715bbe02091236bd26e877bd526eae24e34eebfd7bf94193276527"
  license "MIT"

  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    bin.install "preowned"
  end

  def caveats
    <<~EOS
      Chat and images need Apple Intelligence turned on in System Settings.
      Run `preowned inventory` to see which models work on this Mac.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/preowned --version")
    assert_match "inventory", shell_output("#{bin}/preowned --help")
  end
end
