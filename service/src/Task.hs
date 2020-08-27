module Task
  ( Task (..)
  , TaskWithId(..)
  ) where

import Control.Monad (when)
import Data.Aeson (genericParseJSON, defaultOptions, ToJSON, FromJSON(..))
import Data.Text (Text)
import GHC.Generics (Generic)
import Language (Language)
import Db.Schema (TaskId)
import qualified Data.Text as Text

data Task = Task
  { name :: String
  , expectedFilename :: String
    -- ^ every test is expected to have some \"expected import\", usually the source file being tested
    -- this is our current mechanism for plugging a student's source file into the test
  , language :: Language
    -- ^ which programming language this task is in
  , tests :: Text
    -- ^ the source code of the test itself
    -- it's expected that the \"expected import\" is already done here
    -- TODO: possible consider manually adding the import
  , description :: Text
  }
  deriving stock (Eq, Show, Generic)
  deriving anyclass (ToJSON)

instance FromJSON Task where
  parseJSON val = do
    let shouldBeNonEmpty str x = when (length x == 0) $ fail $ "A non-empty string is required for the " ++ str ++ " field for Task!"
    task@Task{name, expectedFilename, tests, description} <- genericParseJSON defaultOptions val
    shouldBeNonEmpty "name" name
    shouldBeNonEmpty "expectedFilename" expectedFilename
    shouldBeNonEmpty "tests" $ Text.unpack tests
    shouldBeNonEmpty "description" $ Text.unpack description
    pure task

data TaskWithId = TaskWithId
  { taskId :: TaskId
  , task :: Task
  }
  deriving stock (Eq, Show, Generic)
  deriving anyclass (ToJSON, FromJSON)
