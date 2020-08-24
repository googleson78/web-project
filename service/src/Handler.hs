{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE ViewPatterns #-}

module Handler
  ( apiHandler
  ) where

import API (GetSubmissions, GetTasks, GetTask, AddTask, Submit, API, Login)
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
import qualified Db.Result as Db
import qualified Db.Schema as Db
import qualified Db.Task as Db
import Data.Functor (void)

apiHandler :: (MonadMask m, MonadError ServerError m, MonadIO m, MonadReader App m) => ServerT API m
apiHandler =
  login :<|>
  getTasks :<|>
  getTask :<|>
  addTask :<|>
  submit :<|>
  getSubmissions

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

getTask :: (MonadIO m, MonadError ServerError m, MonadReader App m) => ServerT GetTask m
getTask taskId = do
  res <- runQuery $ Persistent.get taskId
  case res of
    Nothing -> throwError err404
    Just task -> pure $ Db.toTask task



addTask :: (MonadIO m, MonadError ServerError m, MonadReader App m) => ServerT AddTask m
addTask cookies task = withUser cookies \_ -> runQuery . Persistent.insert . Db.fromTask $ task

submit :: (MonadMask m, MonadIO m, MonadError ServerError m, MonadReader App m) => ServerT Submit m
submit cookies submission =
  withUser cookies \user -> do
    let taskId = view #task submission

    mtask <- runQuery $ Persistent.get taskId
    case mtask of
      Nothing -> throwError $ err404 {errBody = "There is no such task."}
      Just task -> do
        let program = view #code submission

        result <- maybe (throwError err500) pure =<< runTests (Db.toTask task) program
        userEntity <- runQuery $ getBy $ Db.UniqueUsername $ view #name user
        case userEntity of
          Nothing -> throwError err401 -- shouldn't be possible, we just looked up this user in our users map
          Just (entityKey -> userId) -> do
            void $ runQuery $ Persistent.insert $ Db.fromProgramResult userId taskId program result
            pure result

getSubmissions :: (MonadIO m, MonadError ServerError m, MonadReader App m) => ServerT GetSubmissions m
getSubmissions cookies taskId =
  withUser cookies \user -> do
    userEntity <- runQuery $ getBy $ Db.UniqueUsername $ view #name user
    case userEntity  of
      Nothing -> throwError err401
      Just (entityKey -> userId) -> do
        fmap (map (Db.toProgramWithResult . entityVal)) $ runQuery $ select $ from \result -> do
          where_ $ result ^. Db.ResultUser ==. val userId
          where_ $ result ^. Db.ResultTask ==. val taskId

          pure result

withUser :: (MonadIO m, MonadError ServerError m, MonadReader App m) => Maybe Cookies -> (User -> m a) -> m a
withUser cookies f =
  case fmap (view #token) cookies of
    Nothing -> throwError $ err401 {errBody = "An authorization \"token\" (passed as a cookie) is required for submitting a result."}
    Just token ->
      getUser token >>= \case
        Nothing -> throwError $ err403 {errBody = "No user exists for the given token."}
        Just user -> f user
