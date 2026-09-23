cask "zorite" do
  arch arm: "arm64", intel: "amd64"

  version "0.12.0"
  sha256 arm:   "2413e082dba11a64a1bfbc8b6ca9bd850d0521962fda65d200fd020a4379a975",
         intel: "410dd2c9351f7fc21b3fb67c9675001ad43459f597d79af1bdad5629fc42f8cc"

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
