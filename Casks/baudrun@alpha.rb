cask "baudrun@alpha" do
  arch arm: "aarch64", intel: "x64"

  version "0.9.6-beta.3"
  sha256 arm:   "47a2ac0e222eb68cd529fa0d15f78b32def6a99ad765d4605197fdb7e9a3d4df",
         intel: "70d9a860731f86a0c1e8e7bf749ba2ceb2b04e07fb72d1f55de854cde574fad0"

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
