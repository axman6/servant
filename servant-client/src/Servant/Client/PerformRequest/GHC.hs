{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ViewPatterns #-}

{-# OPTIONS_GHC -fno-warn-name-shadowing #-}

module Servant.Client.PerformRequest.GHC (
  ServantError(..),
  performHttpRequest,
  ) where

import           Control.Exception
import qualified Data.ByteString.Lazy as LBS
import           Data.IORef
import           Network.HTTP.Client
import           Network.HTTP.Client.TLS
import           System.IO.Unsafe

import           Servant.Client.PerformRequest.Base

performHttpRequest :: Request -> IO (Either ServantError (Response LBS.ByteString))
performHttpRequest request =
  __withGlobalManager $ \ manager ->
    catchConnectionError $
      httpLbs request manager

__withGlobalManager :: (Manager -> IO a) -> IO a
__withGlobalManager action = readIORef __manager >>= action

{-# NOINLINE __manager #-}
__manager :: IORef Manager
__manager = unsafePerformIO (newManager tlsManagerSettings >>= newIORef)

catchConnectionError :: IO a -> IO (Either ServantError a)
catchConnectionError action =
  catch (Right <$> action) $ \e ->
    pure . Left . ConnectionError $ SomeException (e :: HttpException)
