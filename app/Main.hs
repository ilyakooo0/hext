{-# LANGUAGE DeriveAnyClass, DeriveGeneric, LambdaCase, NoImplicitPrelude, OverloadedStrings #-}
{-# LANGUAGE RecordWildCards, ScopedTypeVariables, TypeApplications #-}

module Main where

import Relude

import Control.Hext.Arguments
import Control.Hext.Config
import Control.Hext.Processor

main :: IO ()
main = do
    Options{..} <- parseOptions
    configs <- getConfigs extensionsPath
    forM_ configs $ \Config{..} ->
        mapM_ (processFiles lineLimit extensions) $ maybe src pure activeDirectory
