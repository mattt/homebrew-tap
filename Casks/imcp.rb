cask "imcp" do
  version "1.5.0"
  sha256 "a0cf201bca1fe308fc9c19cba1a096456ef187d88b586522c8b367b382490213"

  url "https://github.com/mattt/iMCP/releases/download/#{version}/iMCP.zip"
  name "iMCP"
  desc "MCP server app for your application"
  homepage "https://github.com/mattt/iMCP"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "iMCP.app"

  zap trash: [
    "~/Library/Application Support/iMCP",
    "~/Library/Caches/iMCP",
    "~/Library/Preferences/co.dododo.iMCP.plist",
  ]
end
