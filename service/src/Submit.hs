{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE OverloadedLabels #-}

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
  , result :: Text
  }
  deriving stock Generic
  deriving anyclass (ToJSON, FromJSON)

runTests :: (MonadMask m, MonadIO m) => Task -> Program -> m (Maybe Result)
runTests Task {language, tests, expectedFilename} program =
  withSystemTempDir "" \dir -> withCurrentDir dir do
    liftIO $ do
      Text.writeFile "tests" tests
      Text.writeFile expectedFilename $ getProgram program

    (exitCode, stdout, _) <- readProcess $ proc "racket" ["tests"]

    case exitCode of
      ExitFailure _ -> pure Nothing
      ExitSuccess ->
        let utf8Output = Text.decodeUtf8 $ LBS.toStrict stdout
         in pure $ Just $
              Result
                { passed = containsFailure language utf8Output
                , result = utf8Output
                }

containsFailure :: Language -> Text -> Bool
containsFailure Racket = Text.isInfixOf "FAILURE"
