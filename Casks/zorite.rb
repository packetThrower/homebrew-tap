cask "zorite" do
  arch arm: "arm64", intel: "amd64"

  version "0.6.1"
  sha256 arm:   "dc4165d74253e383ac31f3255be23d87dfed937f22aee4b579fc47642853a625",
         intel: "391803d837782638b07ad893f9cfc6890f19dc1700f8ece719c119677b238484"

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
