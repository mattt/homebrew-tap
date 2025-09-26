class Olleh < Formula
    desc "Ollama-compatible CLI for Apple's Foundation Models"
    homepage "https://github.com/mattt/olleh"
    url "https://github.com/mattt/olleh/archive/refs/tags/1.1.1.tar.gz"
    sha256 "7429da65aef05f4e66958e1bd72462191adddfe35bed951ff10c01906e9f4341"
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