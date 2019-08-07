{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE RecordWildCards #-}

module Main where

import Relude

import Data.Haskell.Parser
import Control.Hext.Arguments
import Control.Hext.Config
import Control.Hext.Processor
import Text.Megaparsec

main :: IO ()
main = do
    Options{..} <- parseOptions
    configs <- getConfigs extensionsPath
    forM_ configs $ \Config{..} ->
        mapM_ (processFiles extensions) $ maybe src pure activeDirectory
