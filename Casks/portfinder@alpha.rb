cask "portfinder@alpha" do
  arch arm: "arm64", intel: "amd64"

  version "4.1.3-beta.1"
  sha256 arm:   "28b858458c1eb2d087b2eff9aeaf6ad893739d16d6aa134b86a20dc3c3a72433",
         intel: "4f59a8f0ce2c6de22500421dae7ce57ef202ae616b2feaacbe61650f547546a9"

  url "https://github.com/packetThrower/PortFinder/releases/download/v#{version}/PortFinder_#{version}_#{arch}.dmg"
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

  depends_on macos: :big_sur

  # Install alongside stable. The DMG always contains "PortFinder.app";
  # `target:` renames it on copy so /Applications can hold both
  # /Applications/PortFinder.app (stable) and
  # /Applications/PortFinder Alpha.app (this cask) at the same time.
  app "PortFinder.app", target: "PortFinder Alpha.app"
  # CLI symlink uses a distinct name so it doesn't collide with the
  # stable cask's `portfinder` shim. Run alpha-channel captures with
  # `portfinder-alpha capture …`. Cargo's `[[bin]] name = "PortFinder"`
  # (capitalised) is what cargo-packager writes into Contents/MacOS/,
  # so the source path is `PortFinder` rather than the 3.x-era
  # lowercase `portfinder`.
  binary "#{appdir}/PortFinder Alpha.app/Contents/MacOS/PortFinder",
         target: "portfinder-alpha"

  # Same Gatekeeper-quarantine strip as the stable cask. cargo-packager
  # ad-hoc signs the .app but doesn't notarize it (no paid Apple
  # Developer account), so without this Tahoe (15+) may delete the
  # binary on first launch.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/PortFinder Alpha.app"],
                   sudo: false
  end

  # No `zap` block on purpose. The alpha and stable casks share the
  # same bundle identifier (`io.github.packetThrower.PortFinder`), so
  # the Application Support / Preferences / Caches paths are written
  # to by whichever channel ran most recently. Zapping them from this
  # cask would clobber the stable channel's state. If a user wants a
  # clean uninstall, they can run
  # `brew uninstall --zap --cask portfinder` (the stable variant)
  # which owns the shared paths.

  caveats <<~EOS
    PortFinder Alpha is a pre-release build. State (preferences,
    saved window position, etc.) is shared with the stable
    /Applications/PortFinder.app because both ship with the same
    bundle identifier. The CLI is exposed as `portfinder-alpha` so
    it doesn't collide with the stable `portfinder` symlink.

    Packet capture on macOS still needs the BPF helper. Open
    PortFinder Alpha and click "Install BPF Helper" once, or fall
    back to `sudo portfinder-alpha capture …`. macOS Background
    Items will show the helper as "PortFinder BPF Helper".
  EOS
end
