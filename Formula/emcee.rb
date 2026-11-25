class Emcee < Formula
  desc "MCP generator for OpenAPIs"
  homepage "https://emcee.sh"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattt/emcee/releases/download/v0.9.1/emcee_Darwin_arm64.tar.gz"
      sha256 "3ad3164b8db89fc958cf87a81ac983ad0b470a9695656bb08f30ca3710362bb6"
    end
    on_intel do
      url "https://github.com/mattt/emcee/releases/download/v0.9.1/emcee_Darwin_x86_64.tar.gz"
      sha256 "c1ef7172096136bd81e235eb49100e2a3a74d0966b9ded30e119c27457647834"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mattt/emcee/releases/download/v0.9.1/emcee_Linux_arm64.tar.gz"
      sha256 "dd9dff396fbf19c20d13aae1ac8fb9ac074803e2502ee656a082160eee0fcd29"
    end
    on_intel do
      url "https://github.com/mattt/emcee/releases/download/v0.9.1/emcee_Linux_x86_64.tar.gz"
      sha256 "053db42913356c00cd62c636c67dd3cd0dbb2d9e3a0eca2b102c4f25c93fbcdd"
    end
  end

  def install
    bin.install "emcee"
  end

  test do
    system bin/"emcee", "--version"
  end
end
