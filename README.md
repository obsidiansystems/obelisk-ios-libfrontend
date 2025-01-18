# obelisk-ios-libfrontend

Builds an obelisk frontend as a static library for use in an iOS project. Check out the companion project [obelisk-ios-xcode](https://github.com/obsidiansystems/obelisk-ios-xcode), for an example of how to integrate this into an XCode project.

## Adding the dependency

```sh
mkdir dep
cd dep
nix-thunk create https://github.com/obsidiansystems/obelisk-ios-libfrontend.git
```

Add this package to the [overrides](https://github.com/obsidiansystems/obelisk/#adding-package-overrides) in your obelisk project's default.nix:

```nix
project ./. ({ pkgs, hackGet, ... }: {

...

overrides = self: super: {
  obelisk-ios-libfrontend = pkgs.haskell.lib.dontStrip (self.callCabal2nix "obelisk-ios-libfrontend" (hackGet ./dep/obelisk-ios-libfrontend + "/exe") {});
  obelisk-ios-libfrontendconfig = self.callCabal2nix "obelisk-ios-libfrontendconfig" (hackGet ./dep/obelisk-ios-libfrontend + "/lib") {};
};
```

Make sure to include `dontStrip`.

## Adding iOS config to your frontend code

Add `obelisk-ios-libfrontendconfig` to your frontend's `library`'s `build-depends` in `frontend/frontend.cabal`.

In your `frontend/Frontend.hs`, you'll need to add something like this:

```haskell
...
import Obelisk.Frontend.IOS

...
myHtmlHead = do
  el "title" $ text "Obelisk Minimal Example"
  elAttr "script" ("type" =: "application/javascript" <> "src" =: $(static "lib.js")) blank
  elAttr "link" ("href" =: $(static "main.css") <> "type" =: "text/css" <> "rel" =: "stylesheet") blank

iosConfig :: IO (IosConfig (R FrontendRoute))
iosConfig = do
  html <- fmap snd $ renderStatic $ myHtmlHead
  pure $ IosConfig (\_ -> frontend) $ mconcat
    [ "<!DOCTYPE html><html><head>"
    , html
    , "</head><body></body></html>"
    ]
```

Your Frontend.hs **must** export `iosConfig`.

## Building

To build the static lib, run:

```
nix-build . -A ghcIosAarch64.obelisk-ios-libfrontend --argstr system "x86_64-darwin"
```
