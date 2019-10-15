{-# LANGUAGE DeriveAnyClass, DeriveGeneric, LambdaCase, NoImplicitPrelude, OverloadedStrings #-}
{-# LANGUAGE RecordWildCards, ScopedTypeVariables, TypeApplications #-}

module Data.Haskell.Parser
    ( withoutExtensions
    , withoutExtensionsParser
    ) where

import Relude hiding (many, some)

import Text.Megaparsec
import Text.Megaparsec.Char

withoutExtensions :: Text -> Text
withoutExtensions t = fromMaybe t $ (parseMaybe @()) withoutExtensionsParser t

withoutExtensionsParser :: (Ord e) => ParsecT e Text m Text
withoutExtensionsParser = do
    _ <- many extensionExpr
    takeRest
    where
        extensionExpr = do
            space
            chunk "{-#"
            space
            chunk "LANGUAGE"
            space
            some extensions
            space
            chunk "#-}"
            space

        extensions = do
            some letterChar
            space
            optional $ do
                single ','
                space
                extensions
            return ()
