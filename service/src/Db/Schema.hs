{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Db.Schema
  ( EntityField(..), Key(..), Unique(..)
  , User(..), UserId
  , Task(..), TaskId
  , migrateAll
  ) where

import Database.Persist.Class (EntityField, Key, Unique)
import Database.Persist.TH (share, mkPersist, sqlSettings, mkMigrate, persistLowerCase)
import Data.Text (Text)
import Language (Language)

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
User
  name Text
  password Text

  UniqueUsername name

  deriving Show

Task
  expectedFilename String
  language Language
  tests Text

  deriving Show
|]
