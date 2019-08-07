{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE RecordWildCards #-}

module Control.Hext.Config
    ( getConfigs
    , Config(..)
    ) where

import Relude

import Data.Yaml

data Config = Config
    { extensions :: [Text]
    , src :: [FilePath]
    } deriving (Show, Eq, Ord, Generic, FromJSON)

getConfigs :: FilePath -> IO [Config]
getConfigs = decodeFileThrow
