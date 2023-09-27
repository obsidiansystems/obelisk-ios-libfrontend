{-# Language CPP #-}
module Obelisk.Frontend.IOS where

import Data.ByteString (ByteString)
#ifdef MIN_VERSION_jsaddle_wkwebview
import qualified Language.Javascript.JSaddle.WKWebView as JSaddle
#endif
import Obelisk.Frontend

type Webview =
#ifdef MIN_VERSION_jsaddle_wkwebview
  JSaddle.WKWebView
#else
  ()
#endif

data IosConfig route = IosConfig
  { _iosConfig_frontend :: Maybe Webview -> Frontend route
  , _iosConfig_initialHtml :: ByteString
  }
