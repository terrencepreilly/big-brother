{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Lib
    ( runserver
    , User
    ) where

import Data.Aeson
    ( FromJSON
    , ToJSON
    )
import Network.Wai.Middleware.RequestLogger
import Network.Wai.Middleware.Cors
import GHC.Generics
import Web.Scotty

import qualified Data.Text as T

data User = User
    { username :: String
    } deriving (Show, Generic)
instance ToJSON User
instance FromJSON User

ping :: ActionM ()
ping = do
    d <- jsonData
    json (d :: User)

pingOptions :: ActionM ()
pingOptions = do
    setHeader "Allow" "POST"
    setHeader "Access-Control-Allow-Methods" "POST"
    text "Success"

runserver :: IO ()
runserver = do
    scotty 3000 $ do
        middleware logStdoutDev
        middleware simpleCors
        post "/ping" ping
        options "/ping" pingOptions
