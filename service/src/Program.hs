module Program
  ( Program(..)
  ) where

import Data.Text (Text)
import Data.Aeson (ToJSON)
import Data.Aeson.Types (FromJSON)
import Database.Persist.Sql (PersistField, PersistFieldSql)

newtype Program = Program {getProgram :: Text}
  deriving stock (Eq, Show)
  deriving newtype (FromJSON, ToJSON, PersistField, PersistFieldSql)
