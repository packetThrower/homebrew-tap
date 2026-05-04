cask "baudrun" do
  arch arm: "aarch64", intel: "x64"

  version "0.9.4"
  sha256 arm:   "85c014116f52e0b521775f5446d096b61da533a4f51909613bff41c70f7c6b38",
         intel: "0a448cc9d0738daa26a6593f15b236ba4927e5e6c1709d234745be745a71320c"

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
