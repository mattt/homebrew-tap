cask "repossess" do
  version "0.2.0"
  sha256 "b2653339da0ec095ded312affbd7f60f63395bc235cb1b44b275a5eba7233e6d"

  url "https://github.com/mattt/rePossess/releases/download/#{version}/rePossess-#{version}.zip"
  name "rePossess"
  desc "Menu bar app that connects a reMarkable tablet to MCP clients"
  homepage "https://github.com/mattt/rePossess"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :golden_gate

  app "rePossess.app"
  binary "#{appdir}/rePossess.app/Contents/MacOS/repossess"

  zap trash: [
    "~/Library/Application Support/rePossess",
    "~/Library/Preferences/co.dododo.repossess.plist",
  ]
end
