cask "zorite" do
  arch arm: "arm64", intel: "amd64"

  version "0.4.2"
  sha256 arm:   "0e4f6b0c7f4ced0951d26616db95b0fcfe24c7f7cea65dfe9b36090464428cde",
         intel: "43b52da76de1c4f3a329fb8edbd273df9f9bdf4364c878e33533b97871fb1568"

  url "https://github.com/packetThrower/zorite/releases/download/v#{version}/Zorite_#{version}_#{arch}.dmg"
  name "Zorite"
  desc "Local-first daily-journal and outliner note app (Logseq-style)"
  homepage "https://github.com/packetThrower/zorite"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :big_sur

  app "Zorite.app"

  # Zorite ships ad-hoc signed but not notarized (no paid Apple Developer
  # account yet). Without notarization, macOS Gatekeeper on Tahoe (15+) will
  # quarantine and may delete the binary on first run. Strip the quarantine
  # attribute on install so the app launches without a right-click → Open or a
  # manual `xattr -cr`. Remove this once notarized builds ship.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Zorite.app"],
                   sudo: false
  end

  zap trash: [
    "~/Library/Application Support/zorite",
    "~/Library/Caches/io.github.packetThrower.Zorite",
    "~/Library/Preferences/io.github.packetThrower.Zorite.plist",
    "~/Library/Saved Application State/io.github.packetThrower.Zorite.savedState",
  ]
end
