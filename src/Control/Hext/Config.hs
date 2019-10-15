{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}

module Control.Hext.Config
  ( getConfigs,
    Config (..),
    LineLimit (..),
  )
where

import Data.Aeson as A
import Data.Aeson.Casing
import Data.Scientific
import Data.Yaml
import Relude
import System.Exit as SE

data Config
  = Config
      { extensions :: [Text],
        src :: [FilePath],
        lineLimit :: Maybe LineLimit
      }
  deriving (Show, Eq, Ord, Generic)

instance FromJSON Config where
  parseJSON = genericParseJSON $ defaultOptions {fieldLabelModifier = snakeCase}

data LineLimit
  = Limited Int
  | Unlimited
  deriving (Show, Generic, Eq, Ord)

instance FromJSON LineLimit where
  parseJSON (A.Number n)
    | Right n' <- floatingOrInteger @Double n,
      n' > 0 =
      return $ Limited n'
  parseJSON (A.String "none") = return Unlimited
  parseJSON _ = fail "invalid line-limit value"

getConfigs :: FilePath -> IO [Config]
getConfigs f =
  (fmap . fmap) (\c@Config {..} -> c {extensions = sort extensions}) $
    decodeFileEither f >>= either (SE.die . prettyPrintParseException) return
