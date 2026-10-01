cask "zorite" do
  arch arm: "arm64", intel: "amd64"

  version "0.12.1"
  sha256 arm:   "cb152180691ba9e2366da4815bbc707291fe6576ec76b60d1c3101f1c1ed65c0",
         intel: "a5ef966bd65c0c9d9ee779a047cd100b92f19e9cdbd4b850819e3dcb49c9f350"

  url "https://github.com/packetThrower/zorite/releases/download/v#{version}/Zorite_#{version}_#{arch}.dmg"
  name "Zorite"
  desc "Local-first daily-journal and outliner note app (Logseq-style)"
  homepage "https://github.com/packetThrower/zorite"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "Zorite.app"

  # Zorite ships ad-hoc signed but not notarized (no paid Apple Developer
  # account yet). Without notarization, macOS Gatekeeper on Tahoe (15+) will
  # quarantine and may delete the binary on first run. Strip the quarantine
  # attribute on install so the app launches without a right-click → Open or a
  # manual `xattr -cr`. Remove this once notarized builds ship.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Zorite.app"], must_succeed: false
  end

  zap trash: [
    "~/Library/Application Support/zorite",
    "~/Library/Caches/io.github.packetThrower.Zorite",
    "~/Library/Preferences/io.github.packetThrower.Zorite.plist",
    "~/Library/Saved Application State/io.github.packetThrower.Zorite.savedState",
  ]
end
