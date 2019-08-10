{-# LANGUAGE OverloadedStrings, DeriveGeneric, TypeApplications, NoImplicitPrelude #-}
{-# LANGUAGE DeriveAnyClass, LambdaCase, ScopedTypeVariables, RecordWildCards #-}

module Control.Hext.Arguments
    ( parseOptions
    , Options(..)
    ) where

import Relude

import Options.Applicative

parseOptions :: IO Options
parseOptions = execParser $ info
    (Options <$> activeDirectoryArgument <*> extensionsFilePath)
    (fullDesc
    <> progDesc "Add GHC extensions to source files automatically.")

data Options = Options
    { activeDirectory :: Maybe FilePath
    , extensionsPath :: FilePath
    }

activeDirectoryArgument :: Parser (Maybe FilePath)
activeDirectoryArgument = argument (maybeReader $ (Just . Just))
    ( help "The directiry to scan for .hs files."
    <> value Nothing )

extensionsFilePath :: Parser FilePath
extensionsFilePath = option auto
    ( short 'i'
    <> long "input"
    <> help "The input yaml filw with extensions."
    <> value ".hext.yaml" )
