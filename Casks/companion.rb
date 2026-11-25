cask "companion" do
  version "0.2.2"
  sha256 "0db76449f4aeff6609d49302dd9c17dff17a748955c3a8064c85178877f144cc"

  url "https://github.com/mattt/Companion/releases/download/#{version}/Companion.zip"
  name "Companion"
  desc "MCP client for testing and debugging MCP servers"
  homepage "https://github.com/mattt/Companion"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "Companion.app"

  zap trash: [
    "~/Library/Application Support/Companion",
    "~/Library/Caches/Companion",
    "~/Library/Preferences/co.dododo.Companion.plist",
  ]
end
