cask "imcp" do
  version "1.6.1"
  sha256 "9d2c55916e883dce228cb44b57016465f246dece116bda7e8c1d09500892cc1a"

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
