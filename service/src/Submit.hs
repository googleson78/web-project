{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ViewPatterns #-}

module Submit
  ( Submission (..), Program (..)
  , Result (..)
  , runTests
  ) where

import Data.Aeson (FromJSON, ToJSON)
import Data.Text (Text)
import qualified Db.Schema as Db (TaskId)
import Task (Task(..))
import GHC.Generics (Generic)
import Language (Language(..))
import qualified Data.Text as Text
import qualified Data.Text.Encoding as Text
import qualified Data.Text.IO as Text
import Control.Monad.IO.Class (liftIO, MonadIO)
import Path.IO (withCurrentDir, withSystemTempDir)
import qualified Data.ByteString.Lazy as LBS (toStrict)
import Control.Monad.Catch (MonadMask)
import System.Process.Typed (proc, readProcess)
import System.Exit (ExitCode(..))

newtype Program = Program {getProgram :: Text}
  deriving newtype (FromJSON, ToJSON)

data Submission = Submission
  { task :: Db.TaskId
  , code :: Program
  }
  deriving stock Generic
  deriving anyclass (ToJSON, FromJSON)

data Result = Result
  { passed :: Bool
  , resultOutput :: Text
  , resultError :: Text
  }
  deriving stock Generic
  deriving anyclass (ToJSON, FromJSON)

runTests :: (MonadMask m, MonadIO m) => Task -> Program -> m (Maybe Result)
runTests Task {language, tests, expectedFilename} program =
  withSystemTempDir "" \dir -> withCurrentDir dir do
    liftIO $ do
      Text.writeFile "tests" tests
      Text.writeFile expectedFilename $ getProgram program

    (exitCode, (decodeOutput -> stdout), (decodeOutput -> stderr)) <- readProcess $ proc "racket" ["tests"]

    case exitCode of
      ExitFailure _ -> pure Nothing
      ExitSuccess ->
        pure $ Just $
          Result
            { passed = not (containsFailure language stdout) && not (containsFailure language stderr)
            , resultOutput = stdout
            , resultError = stderr
            }
  where
    decodeOutput = Text.decodeUtf8 . LBS.toStrict

containsFailure :: Language -> Text -> Bool
containsFailure Racket = Text.isInfixOf "FAILURE"
