module Obelisk.Frontend.IOS where

import Data.ByteString (ByteString)
import qualified Language.Javascript.JSaddle.WKWebView as JSaddle

data IosConfig route = IosConfig
  { _iosConfig_frontend :: Maybe JSaddle.WKWebView -> Frontend route
  , _iosConfig_initialHtml :: ByteString
  }
