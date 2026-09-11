class Jishuken < Formula
  desc "Self-verifying memory for agents"
  homepage "https://github.com/mattt/jishuken"
  url "https://github.com/mattt/jishuken/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "06ca7d9a578c51572cacb73021b08d64beeef68afa68796ee2e0f219005db976"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "jishuken")
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
