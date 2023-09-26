{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
import Common.Route
import Data.Default
import Data.Monoid ((<>))
import Foreign.Ptr (castPtr)
import Frontend
import Language.Javascript.JSaddle (JSM)
import Language.Javascript.JSaddle.WKWebView (WKWebView(..), mainBundleResourcePath, run')
import Language.Javascript.JSaddle.WKWebView.Internal (jsaddleMainHTMLWithBaseURL)
import Obelisk.Frontend
import Obelisk.Route.Frontend
import Reflex.Dom hiding (run)

main :: IO ()
main = do
  let Right validFullEncoder = checkEncoder fullRouteEncoder
  run $ \wv -> runFrontend validFullEncoder frontend

-- Custom run function does a few things:
--
-- * Fixes the baseUrl (TODO: upstream fix to reflex-dom)
-- * Sets us up for whenever we need to add more iOS specific functionality
-- * Exposes the WebView from jsaddle-wkview to the frontend.
-- * Sets an attribute on body to fit better on screen
-- * overflow:hidden on body avoids some funky scrolling of the whole app
run :: (Maybe WKWebView -> JSM ()) -> IO ()
run jsm = do
  let indexHtml = "<!DOCTYPE html><html><head></head><body style=\"position:relative;width:100vw;height:100vh;overflow:hidden;\"></body></html>"
  baseUrl <- mainBundleResourcePath >>= \case
    Nothing -> do
      putStrLn "Reflex.Dom.run: unable to find main bundle resource path. Assets may not load properly."
      return ""
    Just p -> do
      putStrLn $ show p
      return $ "file://" <> p <> "/"
  run' def $ \wv -> jsaddleMainHTMLWithBaseURL indexHtml baseUrl (jsm (Just wv)) wv
