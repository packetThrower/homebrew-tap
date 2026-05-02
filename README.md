# homebrew-portfinder

Homebrew tap for [PortFinder](https://github.com/packetThrower/PortFinder) —
a network switch port discovery tool that captures CDP, LLDP, and MNDP
packets to identify what switch, port, and VLAN your device is plugged
into.

The tap ships two channels:

| Cask | Tracks | Installs as |
|---|---|---|
| `portfinder` | latest stable release | `/Applications/PortFinder.app`, CLI as `portfinder` |
| `portfinder@alpha` | latest pre-release (alpha / beta / rc) | `/Applications/PortFinder Alpha.app`, CLI as `portfinder-alpha` |

The two coexist. Install one, both, or neither.

## Stable

```sh
brew tap packetThrower/portfinder
brew install --cask portfinder
```

Or in one step:

```sh
brew install --cask packetThrower/portfinder/portfinder
```

This installs `PortFinder.app` to `/Applications` and symlinks the
headless CLI to `$(brew --prefix)/bin/portfinder`. The same binary
runs as the GUI when launched without args and as the CLI when given
any subcommand:

```sh
portfinder capture --interface en0 --protocol LLDP
portfinder list --with-ip
portfinder privileges
portfinder --help
```

## Alpha (pre-release channel)

```sh
brew install --cask packetThrower/portfinder/portfinder@alpha
```

Installs `PortFinder Alpha.app` to `/Applications` (alongside the
stable `PortFinder.app` if you have it) and exposes the CLI as
`portfinder-alpha`:

```sh
portfinder-alpha capture --interface en0 --protocol LLDP
portfinder-alpha --version
```

State is shared between channels (preferences, saved window
position, app support files) because both ship with the same bundle
identifier `com.packetthrower.portfinder`. If you want isolated
state per channel, run only one at a time. Pre-releases are tested
but not GA — file regressions at
[packetThrower/PortFinder/issues](https://github.com/packetThrower/PortFinder/issues).

## Packet capture privileges

macOS gates `/dev/bpf*` behind root, so capture under a normal user
account requires the BPF helper. After installing, open PortFinder
(or PortFinder Alpha) and click **Install BPF Access** once. That
adds your user to the `access_bpf` group via a LaunchDaemon and
survives reboots / macOS upgrades. Until then, capture works only
via `sudo portfinder capture …` (or `sudo portfinder-alpha …`).

## Update

```sh
brew update
brew upgrade --cask portfinder
brew upgrade --cask portfinder@alpha    # if installed
```

The tap's auto-bump workflow polls the upstream repo every 6 hours
and pushes a fresh manifest whenever a new tag (stable or
pre-release) lands.

## Uninstall

```sh
brew uninstall --cask portfinder
brew uninstall --cask portfinder@alpha   # if installed
brew untap packetThrower/portfinder      # optional
```

`brew uninstall --zap --cask portfinder` clears the shared state
paths (`~/Library/Application Support/PortFinder`, the WebKit cache,
the saved app state). The alpha cask intentionally does NOT zap
those paths since they're shared with stable. The BPF helper
LaunchDaemon, if installed, isn't touched by either uninstall;
remove it manually with
`sudo /Library/Application Support/Wireshark/uninstall_chmodbpf.sh`.

## Reporting issues

Cask bugs (install fails, wrong version, broken livecheck): file in
this repo. App bugs: file at
[packetThrower/PortFinder](https://github.com/packetThrower/PortFinder/issues).

## License

The cask files are released into the public domain via [The Unlicense](LICENSE).
PortFinder itself is licensed separately — see the
[main repo](https://github.com/packetThrower/PortFinder).
