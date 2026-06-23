cask "zorite@alpha" do
  arch arm: "arm64", intel: "amd64"

  version "0.1.0-beta.4"
  sha256 arm:   "f7be19a61f39024533bcd114ecd88547daf93994e54ea3bd427b37ea1d1e618a",
         intel: "eb6e11c110f7b8653af44da5e82cdcf245372dc56b925f749f7c86c1eac354f7"

  url "https://github.com/packetThrower/zorite/releases/download/v#{version}/Zorite_#{version}_#{arch}.dmg"
  name "Zorite Alpha"
  desc "Local-first daily-journal and outliner note app (pre-release channel)"
  homepage "https://github.com/packetThrower/zorite"

  # Track the highest pre-release tag (anything with a `-suffix`). The default
  # :github_latest strategy excludes pre-releases, so go straight at the
  # releases atom and pick versions that carry a SemVer pre-release identifier.
  # Currently tracking v0.1.0-beta.4, the latest pre-release tag.
  livecheck do
    url "https://github.com/packetThrower/zorite/releases.atom"
    regex(/v(\d+(?:\.\d+)+(?:-[\w.]+))/i)
  end

  depends_on macos: :big_sur

  # Install alongside stable. The DMG always contains "Zorite.app"; `target:`
  # renames it on copy so /Applications can hold both /Applications/Zorite.app
  # (stable) and /Applications/Zorite Alpha.app (this cask) at once.
  app "Zorite.app", target: "Zorite Alpha.app"

  # Same Gatekeeper quarantine workaround as the stable cask.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Zorite Alpha.app"],
                   sudo: false
  end

  # Stable and alpha share the same support directories — uninstalling one cask
  # shouldn't wipe data the other still uses. Listed for completeness when
  # removing the last Zorite install.
  zap trash: [
    "~/Library/Application Support/zorite",
    "~/Library/Caches/io.github.packetThrower.Zorite",
    "~/Library/Preferences/io.github.packetThrower.Zorite.plist",
    "~/Library/Saved Application State/io.github.packetThrower.Zorite.savedState",
  ]
end
