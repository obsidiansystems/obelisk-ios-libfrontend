# obelisk-ios-libfrontend

Builds an obelisk frontend as a static library for use in an iOS project

Add this package to the [overrides](https://github.com/obsidiansystems/obelisk/#adding-package-overrides) in your obelisk project's default.nix:

```
    obelisk-ios-libfrontend = haskellLib.dontStrip (self.callCabal2nix "obelisk-ios-libfrontend" (hackGet ./dep/obelisk-ios-libfrontend) {});
```

Make sure to include `dontStrip`.

To build the static lib, run:

```
nix-build . -A ghcIosAarch64.obelisk-ios-libfrontend --argstr system "x86_64-darwin"
```