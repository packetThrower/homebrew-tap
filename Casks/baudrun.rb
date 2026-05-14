cask "baudrun" do
  arch arm: "arm64", intel: "amd64"

  version "0.9.7"
  sha256 arm:   "c9da9cd479adce2b99c3c22dfdd3289c93e76cecc0c3c2623ac257037f3eb8e8",
         intel: "188338ea425df5eed2bbbb1ad33f05b5eb3b60206fad1b0053a9bfe422e00b07"

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
  ]
end
