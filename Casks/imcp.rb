cask "imcp" do
  version "1.6.0"
  sha256 "74fe4271f9a2264b30a028f063f0c346ff9c0a26f59a2a4b60147ed33936f1b6"

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
