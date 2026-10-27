cask "baudrun" do
  arch arm: "arm64", intel: "amd64"

  version "0.16.0"
  sha256 arm:   "e5576d7cdad4e203146c0b770a06f955de92d4fd9a95963775d81be97543ceb8",
         intel: "53892081a2252456aa7f9d87fb30edc8d1f4eb0994d655cc98cdee1a7bf8fe94"

  url "https://github.com/packetThrower/Baudrun/releases/download/v#{version}/Baudrun_#{version}_#{arch}.dmg"
  name "Baudrun"
  desc "Cross-platform serial terminal for network devices"
  homepage "https://github.com/packetThrower/Baudrun"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "Baudrun.app"

  # Baudrun is currently shipped ad-hoc signed but not notarized
  # (no paid Apple Developer account yet — see CHANGELOG 0.9.0).
  # Without notarization, macOS Gatekeeper on Tahoe (15+) will
  # quarantine and may delete the binary on first run. Strip the
  # quarantine attribute on install so the app launches without
  # the user having to right-click → Open or run `xattr -cr` by
  # hand. Remove this once we publish notarized builds.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Baudrun.app"], must_succeed: false
  end

  zap trash: [
    "~/Library/Application Support/Baudrun",
    "~/Library/Caches/io.github.packetThrower.Baudrun",
    "~/Library/Preferences/io.github.packetThrower.Baudrun.plist",
    "~/Library/Saved Application State/io.github.packetThrower.Baudrun.savedState",
  ]
end
