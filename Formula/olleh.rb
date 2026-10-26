class Olleh < Formula
    desc "Ollama-compatible CLI for Apple's Foundation Models"
    homepage "https://github.com/mattt/olleh"
    url "https://github.com/mattt/olleh/archive/refs/tags/1.2.0.tar.gz"
    sha256 "f5c2e46c3f058ee29d3355953e1a0e2de86ac763db720c9504aac30c4f67a8a6"
    license "MIT"
  
    depends_on xcode: [">= 26.0", :build]
    depends_on macos: [:tahoe]
  
    def install
      system "swift", "build", "--disable-sandbox", "--configuration", "release"
      bin.install ".build/release/olleh"
    end
  
    test do
      system "olleh", "--help"
    end
  end