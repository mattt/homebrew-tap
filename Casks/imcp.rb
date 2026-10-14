cask "imcp" do
  version "1.7.0"
  sha256 "2054c2f9b5fdc964f2eaac2d723c144c0439a87d49c911c6b46040921cbb0e83"

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
