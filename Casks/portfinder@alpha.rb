cask "portfinder@alpha" do
  version "3.3.0-alpha.2"
  sha256 "76bfc20616514038057e97f1eb46fe3e68577e5cdf90431ea71e07a3378a70fa"

  url "https://github.com/packetThrower/PortFinder/releases/download/v#{version}/PortFinder_#{version}_universal.dmg"
  name "PortFinder Alpha"
  desc "Network switch port discovery via CDP / LLDP / MNDP (pre-release channel)"
  homepage "https://github.com/packetThrower/PortFinder"

  # Track the highest pre-release tag (anything with a `-suffix`). The
  # default :github_latest strategy excludes pre-releases, so we go
  # straight at the releases atom and pick versions that include a
  # SemVer 2 pre-release identifier.
  livecheck do
    url "https://github.com/packetThrower/PortFinder/releases.atom"
    regex(/v(\d+(?:\.\d+)+(?:-[\w.]+))/i)
  end

  depends_on macos: ">= :big_sur"

  # Install alongside stable. The DMG always contains "PortFinder.app";
  # `target:` renames it on copy so /Applications can hold both
  # /Applications/PortFinder.app (stable) and
  # /Applications/PortFinder Alpha.app (this cask) at the same time.
  app "PortFinder.app", target: "PortFinder Alpha.app"
  # CLI symlink uses a distinct name so it doesn't collide with the
  # stable cask's `portfinder` shim. Run alpha-channel captures with
  # `portfinder-alpha capture …`.
  binary "#{appdir}/PortFinder Alpha.app/Contents/MacOS/portfinder",
         target: "portfinder-alpha"

  # Same Gatekeeper-quarantine strip as the stable cask. Tauri builds
  # are ad-hoc signed but not notarized, so without this Tahoe (15+)
  # may delete the binary on first launch.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/PortFinder Alpha.app"],
                   sudo: false
  end

  # No `zap` block on purpose. The alpha and stable casks share the
  # same bundle identifier (`com.packetthrower.portfinder`), so the
  # Application Support / Preferences / WebKit cache paths are
  # written to by whichever channel ran most recently. Zapping them
  # from this cask would clobber the stable channel's state. If a
  # user wants a clean uninstall, they can run
  # `brew uninstall --zap --cask portfinder` (the stable variant)
  # which owns the shared paths.

  caveats <<~EOS
    PortFinder Alpha is a pre-release build. State (preferences,
    saved window position, etc.) is shared with the stable
    /Applications/PortFinder.app because both ship with the same
    bundle identifier. The CLI is exposed as `portfinder-alpha` so
    it doesn't collide with the stable `portfinder` symlink.

    Packet capture on macOS still needs the BPF helper. Open
    PortFinder Alpha and click "Install BPF Access" once, or fall
    back to `sudo portfinder-alpha capture …`.
  EOS
end
