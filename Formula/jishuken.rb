class Jishuken < Formula
  desc "Self-verifying memory for agents"
  homepage "https://github.com/mattt/jishuken"
  license "MIT"
  revision 1

  depends_on arch: [:arm64, :x86_64]

  on_macos do
    depends_on macos: :big_sur

    on_arm do
      url "https://github.com/mattt/jishuken/releases/download/v0.1.0/jishuken-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "dc9b0205e516fff6267b68482a3c885f829a1df89fe919e353b265f274dac319"
    end
    on_intel do
      url "https://github.com/mattt/jishuken/releases/download/v0.1.0/jishuken-v0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "ca7e8485260ab1c355a6af40c177e5d62bb233a0cbb8b3ca0274de08c5fb0640"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mattt/jishuken/releases/download/v0.1.0/jishuken-v0.1.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7c217cffe01b918cb1b3241756333aa071986115cc981fd4783089464a7a58fa"
    end
    on_intel do
      url "https://github.com/mattt/jishuken/releases/download/v0.1.0/jishuken-v0.1.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a38e6c635d143b54e59b910480574a3f323ecb86a9111f075c2dc39fc2ad9803"
    end
  end

  def install
    bin.install "ken"
  end

  def caveats
    <<~EOS
      The command is named ken.
      Install Deno to use generator scripts and source handlers:
        brew install deno
    EOS
  end

  test do
    system bin/"ken", "init"
    system bin/"ken", "add", "release.owner", "ryu", "--half-life", "P3D"
    fact = JSON.parse(shell_output("#{bin}/ken recall release.owner --json"))
    assert_equal "ryu", fact.fetch("value")
  end
end
