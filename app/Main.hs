{-# LANGUAGE OverloadedStrings, DeriveGeneric, TypeApplications, NoImplicitPrelude #-}
{-# LANGUAGE DeriveAnyClass, LambdaCase, ScopedTypeVariables, RecordWildCards #-}

module Main where

import Relude

import Control.Hext.Arguments
import Control.Hext.Config
import Control.Hext.Processor
import Data.Haskell.Parser
import Text.Megaparsec

main :: IO ()
main = do
    Options{..} <- parseOptions
    configs <- getConfigs extensionsPath
    forM_ configs $ \Config{..} ->
        mapM_ (processFiles lineLimit extensions) $ maybe src pure activeDirectory
