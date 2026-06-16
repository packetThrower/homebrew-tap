# homebrew-tap

Homebrew tap for [packetThrower](https://github.com/packetThrower)
projects:

| Cask | Project | Tracks | Installs as |
|---|---|---|---|
| `portfinder` | [PortFinder](https://github.com/packetThrower/PortFinder) | latest stable release | `/Applications/PortFinder.app`, CLI as `portfinder` |
| `portfinder@alpha` | PortFinder | latest pre-release (alpha / beta / rc) | `/Applications/PortFinder Alpha.app`, CLI as `portfinder-alpha` |
| `baudrun` | [Baudrun](https://github.com/packetThrower/Baudrun) | latest stable release | `/Applications/Baudrun.app` |
| `baudrun@alpha` | Baudrun | latest pre-release (alpha / beta / rc) | `/Applications/Baudrun Alpha.app` |
| `etch341` | [etch341](https://github.com/packetThrower/etch341) | latest stable release | `/Applications/etch341.app`, CLI as `etch341` |
| `etch341@alpha` | etch341 | latest pre-release (alpha / beta / rc) | `/Applications/etch341 Alpha.app`, CLI as `etch341-alpha` |
| `zorite` | [Zorite](https://github.com/packetThrower/zorite) | latest stable release | `/Applications/Zorite.app` |
| `zorite@alpha` | Zorite | latest pre-release (alpha / beta / rc) | `/Applications/Zorite Alpha.app` |

Stable and alpha for each project coexist — install one, several, or
none. State is shared between channels (preferences, app support
files) because each project's stable + alpha ship under the same
bundle identifier.

## Trusting the tap (Homebrew 6.0.0+)

As of [Homebrew 6.0.0](https://brew.sh/2026/06/11/homebrew-6.0.0/) (June 2026),
third-party taps must be **trusted** before Homebrew evaluates their Ruby — a
tap is a git repository of code that runs with your privileges, so this is a
security gate. Tap and trust this tap once, then any `brew install --cask …`
below works:

```sh
brew tap packetThrower/tap
brew trust packetThrower/tap          # trust the whole tap
```

To trust just one cask instead of the whole tap, use e.g.
`brew trust --cask packetThrower/tap/baudrun`. See Homebrew's
[Tap Trust](https://docs.brew.sh/Tap-Trust) documentation for details.

## Migration from `homebrew-portfinder`

This tap was renamed from `homebrew-portfinder` to `homebrew-tap`
when Baudrun was added. GitHub auto-redirects the old name for a
while but you'll want to re-tap to pick up the canonical URL:

```sh
brew untap packetThrower/portfinder
brew tap packetThrower/tap
```

Already-installed casks keep working through the redirect; the
re-tap just points future updates at the right place.

## PortFinder

Network switch port discovery — captures CDP, LLDP, and MNDP packets
to identify what switch, port, and VLAN your device is plugged into.

```sh
brew install --cask packetThrower/tap/portfinder
# or pre-release channel:
brew install --cask packetThrower/tap/portfinder@alpha
```

The same binary runs as the GUI when launched without args and as
the CLI when given a subcommand:

```sh
portfinder capture --interface en0 --protocol LLDP
portfinder list --with-ip
portfinder privileges
portfinder --help
```

The alpha cask exposes the CLI as `portfinder-alpha` so it doesn't
collide with stable.

### Packet capture privileges

macOS gates `/dev/bpf*` behind root, so capture under a normal user
account requires the BPF helper. After installing, open PortFinder
and click **Install BPF Access** once — that adds your user to the
`access_bpf` group via a LaunchDaemon and survives reboots / macOS
upgrades. Until then, capture works only via `sudo portfinder
capture …`.

The BPF helper isn't touched by `brew uninstall`; remove it manually
with `sudo /Library/Application Support/Wireshark/uninstall_chmodbpf.sh`
if you need to.

## Baudrun

Cross-platform serial terminal for network devices — switches,
routers, console servers. Auto-detects USB-serial adapter chipsets
(CP210x, FTDI, CH340, PL2303), syntax-highlights vendor configs
(Cisco IOS / IOS XR, Juniper Junos, Aruba AOS-CX, Arista EOS,
MikroTik RouterOS), runs XMODEM/YMODEM file transfer.

```sh
brew install --cask packetThrower/tap/baudrun
# or pre-release channel:
brew install --cask packetThrower/tap/baudrun@alpha
```

GUI-only — no CLI. Stable and alpha install side-by-side as
`/Applications/Baudrun.app` and `/Applications/Baudrun Alpha.app`
respectively.

## etch341

Cross-platform CLI/GUI flash programmer for the CH341A USB SPI/I²C
interface. Auto-detects SPI NOR chips via JEDEC ID or SFDP,
reads / writes / verifies / erases, decodes status registers, ships
a built-in chip database (W25Q, MX25L, MX25U, GD25Q, SST25VF,
AT25SF, EON, PUYA, ISSI, 24Cxx I²C).

```sh
brew install --cask packetThrower/tap/etch341
# or pre-release channel:
brew install --cask packetThrower/tap/etch341@alpha
```

The same binary runs as the GUI when launched without args and as
the CLI when given a subcommand:

```sh
etch341 detect                       # JEDEC ID + chip lookup
etch341 read -o bios.bin             # dump entire chip
etch341 read -o - | sha256sum        # pipe-friendly stdout mode
etch341 sfdp                         # decoded JESD216 table
etch341 sr                           # SR1/SR2/SR3 decoded
etch341 write -i bios.bin            # erase + write + verify
```

The alpha cask installs side-by-side as `/Applications/etch341 Alpha.app`
and exposes the CLI as `etch341-alpha` so it doesn't collide with stable.

### Hardware setup

The CH341A USB programmer doesn't need a driver on macOS — libusb
is statically linked into the binary and macOS leaves the device's
vendor interface alone. Plug it in, run `etch341 detect`, you're
done. Use the bundled SOIC-8 clip or the on-board ZIF socket
depending on whether the chip is in-circuit.

## Zorite

Local-first, Logseq-style daily-journal and outliner note app — Markdown
notes in a local SQLite database, with an infinite-scroll journal of daily
pages plus linked `[[wiki-link]]` pages, whiteboards, PDF viewing, and
full-text search.

```sh
brew install --cask packetThrower/tap/zorite
# or pre-release channel:
brew install --cask packetThrower/tap/zorite@alpha
```

GUI-only — no CLI. Stable and alpha install side-by-side as
`/Applications/Zorite.app` and `/Applications/Zorite Alpha.app`.

## Updates

```sh
brew update
brew upgrade --cask portfinder
brew upgrade --cask portfinder@alpha   # if installed
brew upgrade --cask baudrun
brew upgrade --cask baudrun@alpha      # if installed
brew upgrade --cask etch341
brew upgrade --cask etch341@alpha      # if installed
brew upgrade --cask zorite
brew upgrade --cask zorite@alpha       # if installed
```

The tap's auto-bump workflow polls the upstream repos every 6 hours
and pushes a fresh manifest whenever a new tag (stable or
pre-release) lands. Manual run: Actions → "Bump casks on new
release" → Run workflow.

## Uninstall

```sh
brew uninstall --cask portfinder portfinder@alpha
brew uninstall --cask baudrun baudrun@alpha
brew uninstall --cask etch341 etch341@alpha
brew uninstall --cask zorite zorite@alpha
brew untap packetThrower/tap   # optional
```

`brew uninstall --zap …` on a stable cask clears the shared support
paths (`~/Library/Application Support/<App>`, WebKit cache, saved
app state). The alpha casks intentionally also list those paths in
their zap stanza, but only as a fallback for when the stable cask
isn't present — installing both and uninstalling alpha keeps state.

## Reporting issues

Cask bugs (install fails, wrong version, broken livecheck): file in
this repo. App bugs: file at the project's own repo
([PortFinder](https://github.com/packetThrower/PortFinder/issues),
[Baudrun](https://github.com/packetThrower/Baudrun/issues),
[etch341](https://github.com/packetThrower/etch341/issues),
[Zorite](https://github.com/packetThrower/zorite/issues)).

## License

The cask files are released into the public domain via [The
Unlicense](LICENSE). The apps themselves are licensed separately —
see each project repo.
