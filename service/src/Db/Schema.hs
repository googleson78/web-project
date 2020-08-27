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
  , Result(..), ResultId
  , migrateAll
  ) where

import Database.Persist.Class (EntityField, Key, Unique)
import Database.Persist.TH (share, mkPersist, sqlSettings, mkMigrate, persistLowerCase)
import Data.Text (Text)
import Language (Language)
import Program (Program)

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
User
  name Text
  password Text

  UniqueUsername name

  deriving Show

Task
  name String
  expectedFilename String
  language Language
  tests Text
  description Text

  deriving Show

Result
  user UserId
  task TaskId
  program Program
  passed Bool
  output Text
  error Text

  deriving Show
|]
