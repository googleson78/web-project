{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ViewPatterns #-}

module Submit
  ( Submission (..), Program (..)
  , Result (..), ProgramWithResult (..)
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
import Program (Program(..))
import System.Exit (ExitCode(ExitSuccess))

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

data ProgramWithResult = ProgramWithResult
  { program :: Program
  , result :: Result
  }
  deriving stock Generic
  deriving anyclass (ToJSON, FromJSON)

runTests :: (MonadMask m, MonadIO m) => Task -> Program -> m (Maybe Result)
runTests Task {language, tests, expectedFilename} program =
  withSystemTempDir "" \dir -> withCurrentDir dir do
    liftIO $ do
      Text.writeFile "tests" tests
      Text.writeFile expectedFilename $ getProgram program

    (exitCode, (decodeOutput -> stdout), (decodeOutput -> stderr)) <-
      case language of
        Racket -> readProcess $ proc "racket" ["tests"]

    pure $ Just $
      Result
        { passed = exitCode == ExitSuccess && not (containsFailure language stdout) && not (containsFailure language stderr)
        , resultOutput = stdout
        , resultError = stderr
        }
  where
    decodeOutput = Text.decodeUtf8 . LBS.toStrict

containsFailure :: Language -> Text -> Bool
containsFailure Racket = Text.isInfixOf "FAILURE"
