cask "etch341" do
  arch arm: "arm64", intel: "amd64"

  version "0.4.0"
  sha256 arm:   "221b5167504bf7137b906226c69d4264aa296e192ab507c4dc67031b5794fed2",
         intel: "f7be30c511fa0023f8f1826e58099d9ab05df0e11d47e9d62998398b8338218c"

  url "https://github.com/packetThrower/etch341/releases/download/v#{version}/etch341-#{version}-#{arch}-macos.dmg"
  name "etch341"
  desc "Cross-platform CLI/GUI flash programmer for the CH341A USB SPI/I²C interface"
  homepage "https://github.com/packetThrower/etch341"

  # `:github_latest` excludes pre-release tags so the cask stays on
  # stable v0.x.y. etch341 doesn't currently ship a parallel
  # pre-release channel (no `@alpha` cask sibling), but pinning the
  # strategy means a future beta tag won't accidentally bump the
  # stable cask.
  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "etch341.app"
  # Single binary that doubles as the CLI: typing `etch341` in a
  # shell runs the GUI binary in CLI mode (no GUI window opens
  # when a subcommand is passed). Same pattern Baudrun uses — one
  # ship, two surfaces.
  binary "#{appdir}/etch341.app/Contents/MacOS/etch341"

  # etch341 is ad-hoc signed (`signing-identity = "-"`) but not
  # notarized, so macOS Gatekeeper on Tahoe (15+) quarantines the
  # bundle and may delete it on first launch. Strip the quarantine
  # attribute on install so the app opens without the user having
  # to right-click → Open or run `xattr -cr` themselves. Remove
  # this once we publish notarized builds (TODO in the repo).
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/etch341.app"],
                   sudo: false
  end

  # Standard Application-Support / Caches / Preferences paths
  # derived from the bundle identifier
  # (`io.github.packetThrower.etch341` per Cargo.toml's
  # [package.metadata.packager]), plus etch341's XDG-ish
  # `~/.config/etch341/` which is where `prefs.toml` lives
  # (SPI speed, restore-window-bounds toggle, last-used dirs).
  zap trash: [
    "~/.config/etch341",
    "~/Library/Application Support/etch341",
    "~/Library/Caches/io.github.packetThrower.etch341",
    "~/Library/Preferences/io.github.packetThrower.etch341.plist",
    "~/Library/Saved Application State/io.github.packetThrower.etch341.savedState",
  ]
end
