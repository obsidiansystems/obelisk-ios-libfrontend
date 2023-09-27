{-# Language CPP #-}
module Obelisk.Frontend.IOS where

import Data.ByteString (ByteString)
#ifdef ios_HOST_OS
import qualified Language.Javascript.JSaddle.WKWebView as JSaddle
#endif

type Webview =
#ifdef ios_HOST_OS
  JSaddle.WKWebview
#else
  ()
#endif

data IosConfig route = IosConfig
  { _iosConfig_frontend :: Maybe WebView -> Frontend route
  , _iosConfig_initialHtml :: ByteString
  }
