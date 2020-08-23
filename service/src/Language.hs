{-# LANGUAGE TemplateHaskell #-}

module Language
  ( Language(..)
  ) where

import GHC.Generics (Generic)
import Data.Aeson (genericParseJSON, genericToJSON, tagSingleConstructors, ToJSON(..), FromJSON(..), defaultOptions)
import Database.Persist.TH (derivePersistFieldJSON)

data Language
  = Racket
  deriving stock (Show, Eq, Generic)

-- TODO: these can just be anyclass, once there is more than one 'Language' constructor
instance ToJSON Language where
  toJSON = genericToJSON defaultOptions {tagSingleConstructors = True}

instance FromJSON Language where
  parseJSON = genericParseJSON defaultOptions {tagSingleConstructors = True}

derivePersistFieldJSON "Language"
