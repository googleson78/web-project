{-# LANGUAGE RecordWildCards #-}

module Db.Task
  ( toTask, fromTask
  ) where

import qualified Db.Schema as Db
import Task (Task(..))

toTask :: Db.Task -> Task
toTask Db.Task {..} = 
  Task
    { name = taskName
    , expectedFilename = taskExpectedFilename
    , language = taskLanguage
    , tests = taskTests
    , description = taskDescription
    }

fromTask :: Task -> Db.Task
fromTask Task {..} = 
  Db.Task
    { taskName = name
    , taskExpectedFilename = expectedFilename
    , taskLanguage = language
    , taskTests = tests
    , taskDescription = description
    }
