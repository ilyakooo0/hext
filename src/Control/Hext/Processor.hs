{-# LANGUAGE OverloadedStrings, DeriveGeneric, TypeApplications, NoImplicitPrelude #-}
{-# LANGUAGE DeriveAnyClass, LambdaCase, ScopedTypeVariables, RecordWildCards #-}

module Control.Hext.Processor
    ( processFiles
    ) where

import Relude

import Control.Hext.Config
import Data.Haskell.Parser
import Data.List hiding (head, unlines)
import qualified Data.Text as T
import System.Directory.Tree

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

processFile :: Text -> Text -> Text
processFile extensions file =
    extensions
    <> "\n"
    <> withoutExtensions file

wrapExtension :: Text -> Text
wrapExtension ee = "{-# LANGUAGE " <> ee <> " #-}"

baseLength :: Int
baseLength = T.length $ wrapExtension ""

processFiles :: Maybe LineLimit -> [Text] -> FilePath -> IO ()
processFiles limit allExtensions dir = do
    files <- getFiles dir
    forM_ files $ \file -> do
        contents <- readFileText file
        writeFileText file . processFile (wrapExtensions allExtensions) $ contents
    where
        wrapExtensions :: [Text] -> Text
        wrapExtensions [] = ""
        wrapExtensions extensions@(e:ee) = case limit of
            Nothing -> unlines . fmap wrapExtension $ extensions
            Just Unlimited -> unlines . pure . wrapExtension . mconcat . intersperse ", " $ extensions
            Just (Limited n) ->
                let emptyExtra = ([], ee, baseLength + T.length e)
                    ee' = unfoldr (\case
                                        Nothing -> Nothing
                                        (Just current@(_, [], _)) -> Just (current, Nothing)
                                        (Just current@(soFar, ne:next, l)) ->
                                            let thing = (ne:soFar, next, l + T.length ne + 2)
                                            in Just (current, Just thing))
                                (Just emptyExtra)
                    (extraExtensions, eLeft, _) =
                        fromMaybe emptyExtra . viaNonEmpty head . reverse . filter (\(_, _, n') -> n' <= n) $ ee'
                in (wrapExtension . mconcat . intersperse ", " $ e:extraExtensions)
                    <> "\n" <> wrapExtensions eLeft
