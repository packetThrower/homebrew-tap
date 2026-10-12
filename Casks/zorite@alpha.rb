cask "zorite@alpha" do
  arch arm: "arm64", intel: "amd64"

  version "0.12.2-beta.1"
  sha256 arm:   "a376df739485157fe9ac070c3422666adb0b5e81dd6cf4b0dd9d8b179bbb7d1e",
         intel: "087d31a676a147159d77f04903612f39996c757481789e8f30fbbedf1083a244"

  url "https://github.com/packetThrower/zorite/releases/download/v#{version}/Zorite_#{version}_#{arch}.dmg"
  name "Zorite Alpha"
  desc "Local-first daily-journal and outliner note app (pre-release channel)"
  homepage "https://github.com/packetThrower/zorite"

  # Track the highest pre-release tag (anything with a `-suffix`). The default
  # :github_latest strategy excludes pre-releases, so go straight at the
  # releases atom and pick versions that carry a SemVer pre-release identifier.
  # Homebrew reads this URL as the repo's git tags; the pattern is anchored
  # to the whole tag, with the major capped at three digits, so a stray
  # date-style tag can't outrank a real pre-release.
  livecheck do
    url "https://github.com/packetThrower/zorite/releases.atom"
    regex(/^v?(\d{1,3}(?:\.\d+)+-[\w.]+)$/i)
  end

  depends_on :macos

  # Install alongside stable. The DMG always contains "Zorite.app"; `target:`
  # renames it on copy so /Applications can hold both /Applications/Zorite.app
  # (stable) and /Applications/Zorite Alpha.app (this cask) at once.
  app "Zorite.app", target: "Zorite Alpha.app"

  # Same Gatekeeper quarantine workaround as the stable cask.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Zorite Alpha.app"], must_succeed: false
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
