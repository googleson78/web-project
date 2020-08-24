{-# LANGUAGE RecordWildCards #-}

module Db.Result
  ( toProgramWithResult, fromProgramResult
  ) where

import qualified Db.Schema as Db
import Submit (Program, Result(..), ProgramWithResult(..))

toProgramWithResult :: Db.Result -> ProgramWithResult
toProgramWithResult Db.Result {..} =
  ProgramWithResult
    { program = resultProgram
    , result = Result
        { passed = resultPassed
        , ..
        }
    }

fromProgramResult :: Db.UserId -> Db.TaskId -> Program -> Result -> Db.Result
fromProgramResult resultUser resultTask resultProgram Result {..} = Db.Result
  { resultPassed = passed
  , ..
  }
