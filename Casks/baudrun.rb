cask "baudrun" do
  arch arm: "aarch64", intel: "x64"

  version "0.9.2"
  sha256 arm:   "3c1e4214d704126424a87c31df19842b98da0e1328684a5a1f008feba7bdc995",
         intel: "9ec736cd96a2946fcbe3f506934c59812ae0824dcf019ef3e1219d55e6cf95f5"

  url "https://github.com/packetThrower/Baudrun/releases/download/v#{version}/Baudrun_#{version}_#{arch}.dmg"
  name "Baudrun"
  desc "Cross-platform serial terminal for network devices"
  homepage "https://github.com/packetThrower/Baudrun"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "Baudrun.app"

  # Baudrun is currently shipped ad-hoc signed but not notarized
  # (no paid Apple Developer account yet — see CHANGELOG 0.9.0).
  # Without notarization, macOS Gatekeeper on Tahoe (15+) will
  # quarantine and may delete the binary on first run. Strip the
  # quarantine attribute on install so the app launches without
  # the user having to right-click → Open or run `xattr -cr` by
  # hand. Remove this once we publish notarized builds.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Baudrun.app"],
                   sudo: false
  end

  zap trash: [
    "~/Library/Application Support/Baudrun",
    "~/Library/Caches/io.github.packetThrower.Baudrun",
    "~/Library/Preferences/io.github.packetThrower.Baudrun.plist",
    "~/Library/Saved Application State/io.github.packetThrower.Baudrun.savedState",
    "~/Library/WebKit/io.github.packetThrower.Baudrun",
  ]
end
