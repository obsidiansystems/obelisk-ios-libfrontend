{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
import Common.Route
import Data.Default
import Data.Monoid ((<>))
import Foreign.Ptr (castPtr)
import Frontend (iosConfig)
import Language.Javascript.JSaddle (JSM)
import Language.Javascript.JSaddle.WKWebView (WKWebView(..), mainBundleResourcePath, run')
import Language.Javascript.JSaddle.WKWebView.Internal (jsaddleMainHTMLWithBaseURL)
import Obelisk.Frontend
import Obelisk.Frontend.IOS
import Obelisk.Route.Frontend
import Reflex.Dom hiding (run)

main :: IO ()
main = do
  let Right validFullEncoder = checkEncoder fullRouteEncoder
  run $ \wv -> runFrontend validFullEncoder (_iosConfig_frontend iosConfig wv)

-- Custom run function does a few things:
--
-- * Fixes the baseUrl (TODO: upstream fix to reflex-dom)
-- * Sets us up for whenever we need to add more iOS specific functionality
-- * Exposes the WebView from jsaddle-wkview to the frontend.
run :: (Maybe WKWebView -> JSM ()) -> IO ()
run jsm = do
  let indexHtml = _iosConfig_initialHtml iosConfig
  baseUrl <- mainBundleResourcePath >>= \case
    Nothing -> do
      putStrLn "Reflex.Dom.run: unable to find main bundle resource path. Assets may not load properly."
      return ""
    Just p -> do
      putStrLn $ show p
      return $ "file://" <> p <> "/"
  run' def $ \wv -> jsaddleMainHTMLWithBaseURL indexHtml baseUrl (jsm (Just wv)) wv
