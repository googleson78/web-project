{-# LANGUAGE TemplateHaskell #-}

module Language
  ( Language(..)
  ) where

import GHC.Generics (Generic)
import Data.Aeson (ToJSON, FromJSON)
import Database.Persist.TH (derivePersistFieldJSON)

data Language
  = Racket
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON)

derivePersistFieldJSON "Language"
