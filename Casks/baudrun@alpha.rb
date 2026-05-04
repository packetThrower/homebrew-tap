cask "baudrun@alpha" do
  arch arm: "aarch64", intel: "x64"

  version "0.9.5-alpha.5"
  sha256 arm:   "2461cc44588c29d26b09bf2dd3199ac8337e6806aef517836ecba645f3a3dc50",
         intel: "fb3f797de0a034e4de9f3fc8e0c6ee00a78d9cd325c34e4a0765707f3836ea88"

  url "https://github.com/packetThrower/Baudrun/releases/download/v#{version}/Baudrun_#{version}_#{arch}.dmg"
  name "Baudrun Alpha"
  desc "Cross-platform serial terminal for network devices (pre-release channel)"
  homepage "https://github.com/packetThrower/Baudrun"

  # Track the highest pre-release tag (anything with a `-suffix`). The
  # default :github_latest strategy excludes pre-releases, so we go
  # straight at the releases atom and pick versions that include a
  # SemVer 2 pre-release identifier.
  livecheck do
    url "https://github.com/packetThrower/Baudrun/releases.atom"
    regex(/v(\d+(?:\.\d+)+(?:-[\w.]+))/i)
  end

  depends_on macos: ">= :big_sur"

  # Install alongside stable. The DMG always contains "Baudrun.app";
  # `target:` renames it on copy so /Applications can hold both
  # /Applications/Baudrun.app (stable) and
  # /Applications/Baudrun Alpha.app (this cask) at the same time.
  app "Baudrun.app", target: "Baudrun Alpha.app"

  # Same Tahoe gatekeeper quarantine workaround as the stable cask.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Baudrun Alpha.app"],
                   sudo: false
  end

  # Stable and alpha share the same support directories — uninstalling
  # one cask shouldn't wipe data the other still uses. Listed only for
  # completeness when the user is removing the LAST Baudrun install.
  zap trash: [
    "~/Library/Application Support/Baudrun",
    "~/Library/Caches/io.github.packetThrower.Baudrun",
    "~/Library/Preferences/io.github.packetThrower.Baudrun.plist",
    "~/Library/Saved Application State/io.github.packetThrower.Baudrun.savedState",
    "~/Library/WebKit/io.github.packetThrower.Baudrun",
  ]
end
