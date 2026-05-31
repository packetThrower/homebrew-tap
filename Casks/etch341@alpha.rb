cask "etch341@alpha" do
  arch arm: "arm64", intel: "amd64"

  version "0.6.0-beta.1"
  sha256 arm:   "15a0feeeb8eb39d9119048676a45e866c0dc65f404f94d4a6750a3e7cba8231c",
         intel: "fc3e8651b56fd2a07363ab7c05485e80edd0858f42d0f234a7ec9a25ff9a758d"

  url "https://github.com/packetThrower/etch341/releases/download/v#{version}/etch341-#{version}-#{arch}-macos.dmg"
  name "etch341 Alpha"
  desc "Cross-platform CLI/GUI flash programmer for the CH341A USB SPI/I²C interface (pre-release channel)"
  homepage "https://github.com/packetThrower/etch341"

  # Track the highest pre-release tag (anything with a `-suffix`). The
  # default :github_latest strategy excludes pre-releases, so go
  # straight at the releases atom and pick versions that include a
  # SemVer 2 pre-release identifier.
  livecheck do
    url "https://github.com/packetThrower/etch341/releases.atom"
    regex(/v(\d+(?:\.\d+)+(?:-[\w.]+))/i)
  end

  depends_on macos: ">= :big_sur"

  # Install alongside stable. The DMG always contains "etch341.app";
  # `target:` renames it on copy so /Applications can hold both
  # /Applications/etch341.app (stable) and
  # /Applications/etch341 Alpha.app (this cask) at the same time.
  app "etch341.app", target: "etch341 Alpha.app"

  # Single binary that doubles as the CLI (the GUI binary runs in CLI
  # mode when a subcommand is passed). `target:` renames the shim to
  # `etch341-alpha` so it coexists on $PATH with the stable cask's
  # `etch341`.
  binary "#{appdir}/etch341 Alpha.app/Contents/MacOS/etch341",
         target: "etch341-alpha"

  # etch341 is ad-hoc signed (`signing-identity = "-"`) but not
  # notarized, so macOS Gatekeeper on Tahoe (15+) quarantines the
  # bundle and may delete it on first launch. Strip the quarantine
  # attribute on install so the app opens without the user having to
  # right-click → Open or run `xattr -cr` themselves.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/etch341 Alpha.app"],
                   sudo: false
  end

  # Stable and alpha share the same Application-Support / Caches /
  # Preferences paths plus etch341's XDG-ish `~/.config/etch341/`
  # (where `prefs.toml` lives). Listed for completeness when removing
  # the LAST etch341 install — uninstalling one channel shouldn't wipe
  # the other's state.
  zap trash: [
    "~/.config/etch341",
    "~/Library/Application Support/etch341",
    "~/Library/Caches/io.github.packetThrower.etch341",
    "~/Library/Preferences/io.github.packetThrower.etch341.plist",
    "~/Library/Saved Application State/io.github.packetThrower.etch341.savedState",
  ]
end
