{-# LANGUAGE OverloadedStrings, DeriveGeneric, TypeApplications, NoImplicitPrelude #-}
{-# LANGUAGE DeriveAnyClass, LambdaCase, ScopedTypeVariables, RecordWildCards #-}

module Control.Hext.Config
    ( getConfigs
    , Config(..)
    , LineLimit(..)
    ) where

import Relude

import Data.Aeson as A
import Data.Aeson.Casing
import Data.Scientific
import Data.Yaml
import System.Exit as SE

data Config = Config
    { extensions :: [Text]
    , src :: [FilePath]
    , lineLimit :: Maybe LineLimit
    } deriving (Show, Eq, Ord, Generic)

instance FromJSON Config where
    parseJSON = genericParseJSON $ defaultOptions { fieldLabelModifier = snakeCase }

data LineLimit
    = Limited Int
    | Unlimited
    deriving (Show, Generic, Eq, Ord)

instance FromJSON LineLimit where
    parseJSON (A.Number n)
        | Right n' <- floatingOrInteger n
        , n' > 0
        = return $ Limited n'
    parseJSON (A.String "none") = return Unlimited
    parseJSON _ = fail "invalid line-limit value"

getConfigs :: FilePath -> IO [Config]
getConfigs f = decodeFileEither f >>= either (SE.die . prettyPrintParseException) return
