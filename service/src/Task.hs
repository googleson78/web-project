module Task
  ( Task (..)
  ) where

import Data.Aeson (ToJSON, FromJSON)
import Data.Text (Text)
import GHC.Generics (Generic)
import Language (Language)

data Task = Task
  { expectedFilename :: String
    -- ^ every test is expected to have some \"expected import\", usually the source file being tested
    -- this is our current mechanism for plugging a student's source file into the test
  , language :: Language
    -- ^ which programming language this task is in
  , tests :: Text
    -- ^ the source code of the test itself
    -- it's expected that the \"expected import\" is already done here
    -- TODO: possible consider manually adding the import
  }
  deriving stock (Eq, Show, Generic)
  deriving anyclass (ToJSON, FromJSON)
