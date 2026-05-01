# homebrew-portfinder

Homebrew tap for [PortFinder](https://github.com/packetThrower/PortFinder) —
a network switch port discovery tool that captures CDP, LLDP, and MNDP
packets to identify what switch, port, and VLAN your device is plugged
into.

## Install

```sh
brew tap packetThrower/portfinder
brew install --cask portfinder
```

Or in one step:

```sh
brew install --cask packetThrower/portfinder/portfinder
```

This installs `PortFinder.app` to `/Applications` and symlinks the
headless CLI to `$(brew --prefix)/bin/portfinder`. The same binary runs
as the GUI when launched without args and as the CLI when given any
subcommand:

```sh
portfinder capture --interface en0 --protocol LLDP
portfinder list --with-ip
portfinder privileges
portfinder --help
```

## Packet capture privileges

macOS gates `/dev/bpf*` behind root, so capture under a normal user
account requires the BPF helper. After installing, open PortFinder and
click **Install BPF Access** once — that adds your user to the
`access_bpf` group via a LaunchDaemon and survives reboots / macOS
upgrades. Until you've installed the helper, capture works only via
`sudo portfinder capture …`.

## Update

```sh
brew update
brew upgrade --cask portfinder
```

## Uninstall

```sh
brew uninstall --cask portfinder
brew untap packetThrower/portfinder    # optional
```

`brew uninstall --zap --cask portfinder` also clears
`~/Library/Application Support/PortFinder`, the `WebKit` cache, and
the saved app state. The BPF helper LaunchDaemon (if you installed it)
isn't touched — remove it manually with
`sudo /Library/Application Support/Wireshark/uninstall_chmodbpf.sh`.

## Reporting issues

Cask bugs (install fails, wrong version, broken livecheck): file in
this repo. App bugs: file at
[packetThrower/PortFinder](https://github.com/packetThrower/PortFinder/issues).

## License

The cask file is released into the public domain via [The Unlicense](LICENSE).
PortFinder itself is licensed separately — see the
[main repo](https://github.com/packetThrower/PortFinder).
