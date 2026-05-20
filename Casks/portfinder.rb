cask "portfinder" do
  arch arm: "arm64", intel: "amd64"

  version "4.1.1"
  sha256 arm:   "2e7fd925d4b378293fe0f34f4f6349a7ff4272db52563fd878fce625499f1890",
         intel: "b2e7529863591797f5cf016f7987c3c67bb05f62775c8b62c6b41ccd5333c51c"

  url "https://github.com/packetThrower/PortFinder/releases/download/v#{version}/PortFinder_#{version}_#{arch}.dmg"
  name "PortFinder"
  desc "Network switch port discovery via CDP / LLDP / MNDP"
  homepage "https://github.com/packetThrower/PortFinder"

  # `:github_latest` excludes pre-release tags so the cask stays on
  # stable 4.x.y / 5.x.y releases and never picks up the parallel
  # `@alpha` channel even though both ship from the same repo.
  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "PortFinder.app"
  # CLI shim. The 4.x bin name is capitalised (`PortFinder`, matching
  # CFBundleExecutable + the macOS dock label); the 3.x cask had it
  # lowercased because the Tauri build's binary was lowercase. Target
  # stays `portfinder` so users keep typing the same command they
  # always did.
  binary "#{appdir}/PortFinder.app/Contents/MacOS/PortFinder", target: "portfinder"

  # PortFinder is currently shipped ad-hoc signed but not notarized, so
  # macOS Gatekeeper on Tahoe (15+) will quarantine and may delete the
  # binary on first run. Strip the quarantine attribute on install so the
  # app launches without the user having to right-click → Open or run
  # `xattr -cr` themselves. Remove this once we publish notarized builds.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/PortFinder.app"],
                   sudo: false
  end

  # 4.x identifier scheme is `io.github.packetThrower.PortFinder`,
  # replacing the legacy 3.x `com.packetthrower.portfinder`. Both
  # listed so `--zap` on an in-place 3.x → 4.x upgrade clears state
  # from either generation of the app.
  zap trash: [
    "~/Library/Application Support/PortFinder",
    "~/Library/Caches/io.github.packetThrower.PortFinder",
    "~/Library/Preferences/io.github.packetThrower.PortFinder.plist",
    "~/Library/Saved Application State/io.github.packetThrower.PortFinder.savedState",
    "~/Library/Caches/com.packetthrower.portfinder",
    "~/Library/Preferences/com.packetthrower.portfinder.plist",
    "~/Library/Saved Application State/com.packetthrower.portfinder.savedState",
    "~/Library/WebKit/com.packetthrower.portfinder",
  ]

  caveats <<~EOS
    Packet capture on macOS needs read access to /dev/bpf*. PortFinder
    can install a one-time helper that grants the `access_bpf` group to
    your user — open the app and click "Install BPF Helper" once after
    install. Until then, capture works only under sudo:

      sudo portfinder capture --interface en0 --protocol LLDP

    The helper survives reboots and macOS upgrades. In macOS System
    Settings → General → Login Items & Extensions the helper appears
    as "PortFinder BPF Helper". Uninstall via the standalone
    `PortFinder-BPF-<version>.pkg` from the release assets, or by
    running `sudo /Library/Application\\ Support/PortFinder/uninstall-bpf.sh`
    if you have a copy.
  EOS
end
