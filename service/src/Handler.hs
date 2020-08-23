{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE ViewPatterns #-}

module Handler
  ( apiHandler
  ) where

import API (GetTasks, AddTask, Submit, API, Login)
import App (getUser, registerNewToken, App, runQuery)
import Control.Monad.Catch (MonadMask)
import Control.Monad.Except (MonadError)
import Control.Monad.IO.Class (MonadIO)
import Control.Monad.Reader.Class (MonadReader)
import Cookies (Cookies)
import Data.Generics.Labels ()
import Database.Esqueleto
import Lens.Micro.Extras (view)
import Prelude hiding (lookup)
import Servant (err403, err401, ServerT)
import Servant (err404)
import Servant (err500, ServerError(..), throwError, (:<|>)(..))
import Submit (runTests)
import Task (TaskWithId(..))
import User (User)
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
    convert :: Entity Db.Task -> TaskWithId
    convert Entity {entityKey, entityVal} = TaskWithId entityKey $ Db.toTask entityVal


addTask :: (MonadIO m, MonadError ServerError m, MonadReader App m) => ServerT AddTask m
addTask cookies task = withUser cookies \_ -> runQuery . Persistent.insert . Db.fromTask $ task

-- TODO: associate submissions with users
submit :: (MonadMask m, MonadIO m, MonadError ServerError m, MonadReader App m) => ServerT Submit m
submit cookies submission =
  withUser cookies \_ -> do
    mtask <- runQuery $ Persistent.get $ view #task submission
    case mtask of
      Nothing -> throwError $ err404 {errBody = "There is no such task."}
      Just task -> maybe (throwError err500) pure =<< runTests (Db.toTask task) (view #code submission)

withUser :: (MonadIO m, MonadError ServerError m, MonadReader App m) => Maybe Cookies -> (User -> m a) -> m a
withUser cookies f =
  case fmap (view #token) cookies of
    Nothing -> throwError $ err401 {errBody = "An authorization \"token\" (passed as a cookie) is required for submitting a result."}
    Just token ->
      getUser token >>= \case
        Nothing -> throwError $ err403 {errBody = "No user exists for the given token."}
        Just user -> f user
