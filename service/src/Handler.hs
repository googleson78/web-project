{-# LANGUAGE ViewPatterns #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}

module Handler
  ( apiHandler
  ) where

import API (GetTasks, AddTask, Submit, API, Login)
import App (registerNewToken, App, runQuery)
import Control.Monad.Catch (MonadMask)
import Control.Monad.Except (MonadError)
import Control.Monad.IO.Class (MonadIO)
import Control.Monad.Reader.Class (MonadReader)
import Data.Generics.Labels ()
import Database.Esqueleto
import Lens.Micro.Extras (view)
import Prelude hiding (lookup)
import Servant (err401, ServerT)
import Servant (err404)
import Servant (err500, ServerError(..), throwError, (:<|>)(..))
import Task (Task)
import Submit (runTests)
import qualified Database.Persist as Persistent
import qualified Db.Schema as Db
import qualified Db.Task as Db

apiHandler :: (MonadMask m, MonadError ServerError m, MonadIO m, MonadReader App m) => ServerT API m
apiHandler =
  login :<|>
  getTasks :<|>
  addTask :<|>
  submit

login :: (MonadError ServerError m, MonadIO m, MonadReader App m) => ServerT Login m
login user = do
  found <- runQuery $ getBy $ Db.UniqueUsername $ view #name user
  case found of
    Nothing -> throwError err401
    Just (entityVal -> dbUser)
      | Db.userPassword dbUser == view #password user -> registerNewToken user
      | otherwise -> throwError err401

getTasks :: (MonadIO m, MonadReader App m) => ServerT GetTasks m
getTasks = fmap (map convert) $ runQuery $ select $ from pure
  where
    convert :: Entity Db.Task -> (Db.TaskId, Task)
    convert Entity {entityKey, entityVal} = (entityKey, Db.toTask entityVal)


addTask :: (MonadIO m, MonadReader App m) => ServerT AddTask m
addTask = runQuery . Persistent.insert . Db.fromTask

submit :: (MonadMask m, MonadIO m, MonadError ServerError m, MonadReader App m) => ServerT Submit m
submit submission  = do
  mtask <- runQuery $ Persistent.get $ view #task submission
  case mtask of
    Nothing -> throwError $ err404 {errBody = "There is no such task."}
    Just task -> maybe (throwError err500) pure =<< runTests (Db.toTask task) (view #code submission)
