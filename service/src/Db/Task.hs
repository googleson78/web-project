{-# LANGUAGE RecordWildCards #-}

module Db.Task
  ( toTask, fromTask
  ) where

import qualified Db.Schema as Db
import Task (Task(..))

toTask :: Db.Task -> Task
toTask Db.Task {..} = 
  Task
    { expectedFilename = taskExpectedFilename
    , language = taskLanguage
    , tests = taskTests
    }

fromTask :: Task -> Db.Task
fromTask Task {..} = 
  Db.Task
    { taskExpectedFilename = expectedFilename
    , taskLanguage = language
    , taskTests = tests
    }
