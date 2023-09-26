# obelisk-ios-libfrontend

Builds an obelisk frontend as a static library for use in an iOS project

Add this package to the [overrides](https://github.com/obsidiansystems/obelisk/#adding-package-overrides) in your obelisk project's default.nix, then run:

```
nix-build . -A ghcIosAarch64.obelisk-ios-libfrontend --argstr system "x86_64-darwin"
```