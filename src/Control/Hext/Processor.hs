{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE RecordWildCards #-}

module Control.Hext.Processor
    ( processFiles
    ) where

import Relude

import Data.List hiding (unlines)
import System.Directory.Tree
import Data.Haskell.Parser

getFiles :: FilePath -> IO [FilePath]
getFiles dir = do
    (_ :/ tree) <- readDirectoryWith return dir
    return . (>>= getHs) . unwrapDir $ tree
    where
        unwrapDir :: DirTree a -> [DirTree a]
        unwrapDir (Dir _ paths) = paths
        unwrapDir _ = []

        getHs :: DirTree FilePath -> [FilePath]
        getHs (File _ path) | ".hs" `isSuffixOf` path = pure path
        getHs (Dir name paths) | not $ "." `isPrefixOf` name = paths >>= getHs
        getHs _ = []

processFile :: [Text] -> Text -> Text
processFile extensions file =
    (unlines . fmap wrapExtension) extensions
    <> "\n"
    <> withoutExtensions file
        where
            wrapExtension :: Text -> Text
            wrapExtension e = "{-# LANGUAGE " <> e <> " #-}"

processFiles :: [Text] -> FilePath -> IO ()
processFiles extensions dir = do
    files <- getFiles dir
    forM_ files $ \file -> do
        contents <- readFileText file
        writeFileText file . processFile extensions $ contents
