cask "portfinder" do
  version "3.2.0"
  sha256 "f5874428d7519142348d800857ba0011c2e9d933fa750bad797594868f622785"

  url "https://github.com/packetThrower/PortFinder/releases/download/v#{version}/PortFinder_#{version}_universal.dmg"
  name "PortFinder"
  desc "Network switch port discovery via CDP / LLDP / MNDP"
  homepage "https://github.com/packetThrower/PortFinder"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "PortFinder.app"
  # Expose the headless CLI on $PATH. The same binary runs as the GUI when
  # launched without args and as a CLI (`portfinder capture`, `portfinder list`,
  # `portfinder privileges`) when given any subcommand.
  binary "#{appdir}/PortFinder.app/Contents/MacOS/portfinder"

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

  zap trash: [
    "~/Library/Application Support/PortFinder",
    "~/Library/Caches/com.packetthrower.portfinder",
    "~/Library/Preferences/com.packetthrower.portfinder.plist",
    "~/Library/Saved Application State/com.packetthrower.portfinder.savedState",
    "~/Library/WebKit/com.packetthrower.portfinder",
  ]

  caveats <<~EOS
    Packet capture on macOS needs read access to /dev/bpf*. PortFinder
    can install a one-time helper that grants the `access_bpf` group to
    your user — open the app and click "Install BPF Access" once after
    install. Until then, capture works only under sudo:

      sudo portfinder capture --interface en0 --protocol LLDP

    The helper survives reboots and macOS upgrades; uninstall it with
    `sudo /Library/Application Support/Wireshark/uninstall_chmodbpf.sh`
    if you ever need to.
  EOS
end
