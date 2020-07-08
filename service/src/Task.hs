module Task 
  ( Task (..)
  ) where

import Data.Aeson (ToJSON, FromJSON)
import Data.Text (Text)
import GHC.Generics (Generic)
import Language (Language)

data Task = Task
  { expectedFilename :: String
  , language :: Language
  , tests :: Text
  }
  deriving stock (Eq, Show, Generic)
  deriving anyclass (ToJSON, FromJSON)
