class Olleh < Formula
    desc "Ollama-compatible CLI for Apple's Foundation Models"
    homepage "https://github.com/mattt/olleh"
    url "https://github.com/mattt/olleh/archive/refs/tags/1.0.0.tar.gz"
    sha256 "e7f3c233d94fbccd9ab86eb3e3400933cc9f62512fb7b76e4d7f05a7df7453fe"
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