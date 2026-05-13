cask "baudrun@alpha" do
  # arm64 / amd64 naming follows cargo-packager's output convention
  # used by the gpui rewrite (v0.9.7-alpha.1+). The stable cask
  # still uses aarch64/x64 because v0.9.5 was built with Tauri's
  # bundle naming and that file already exists on the Releases page
  # under those filenames; flip the stable cask in lockstep when the
  # next stable ships from the gpui main.
  arch arm: "arm64", intel: "amd64"

  version "0.9.7-alpha.3"
  sha256 arm:   "4f0e064d3267d1328ea438c061cb152ba92558874fc2ac5e7c7f3cbca81c952f",
         intel: "6d4af1bc861d78e0e131ee719d6f0f689c51c8861abc95af6c740f6aa3954201"

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
