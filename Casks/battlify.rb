cask "battlify" do
  version "0.11.0"
  sha256 "ab390a5098c2fd098f8c60ec0fb44c45d92730afc332c14268cc0169cd5e49d4"

  url "https://github.com/broisnischal/battlify/releases/download/v0.11.0/Battlify-0.11.0.dmg"
  name "Battlify"
  desc "Menu bar battery saver and charge limiter for Apple Silicon Macs"
  homepage "https://github.com/broisnischal/battlify"

  depends_on macos: :sonoma
  depends_on arch: :arm64

  app "Battlify.app"

  # The app is signed ad-hoc (not notarized yet). Homebrew quarantines downloads
  # and no longer supports --no-quarantine, so clear the quarantine after install
  # to let the app launch without a Gatekeeper "damaged" warning.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Battlify.app"]
  end

  caveats <<~EOS
    Charge limiting, Low Power Mode, and sleep controls need a small root helper
    (a LaunchDaemon). After first launch, open the Battlify menu-bar item and
    click "Install Helper" — you will be asked for your password once. The helper
    re-enables charging automatically if it ever stops.
  EOS

  uninstall quit: "com.battlify.app"

  zap trash: [
    "~/Library/Application Support/Battlify",
    "~/Library/Preferences/com.battlify.app.plist",
  ]
end
