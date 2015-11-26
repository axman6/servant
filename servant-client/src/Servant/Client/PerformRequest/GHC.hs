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

performHttpRequest :: Manager -> Request
  -> IO (Either ServantError (Response LBS.ByteString))
performHttpRequest manager request =
  catchConnectionError $ httpLbs request manager

catchConnectionError :: IO a -> IO (Either ServantError a)
catchConnectionError action =
  catch (Right <$> action) $ \e ->
    pure . Left . ConnectionError $ SomeException (e :: HttpException)
