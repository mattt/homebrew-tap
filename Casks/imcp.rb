cask "imcp" do
  version "1.6.4"
  sha256 "0f7000d7d6f107b482d798339f6e6ad71fc2e1026eb3020c33a7fe3a8346b490"

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
