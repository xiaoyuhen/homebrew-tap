# xiaoyuhen/tap

Homebrew casks for [PortScope](https://github.com/xiaoyuhen/portscope), a macOS
menu bar app that shows what is listening on your ports.

```sh
brew install --cask xiaoyuhen/tap/portscope
```

PortScope is ad-hoc signed and not notarized, so the cask clears the
quarantine flag after installing; otherwise macOS would refuse to open it.
PortScope updates itself (`auto_updates true`), so `brew upgrade` leaves it to
the app. `brew uninstall --zap --cask portscope` also removes its preferences
and logs.

The cask follows PortScope's GitHub releases: a scheduled workflow checks every
three hours, verifies the release checksum against the downloaded zip, and
commits the new version.
