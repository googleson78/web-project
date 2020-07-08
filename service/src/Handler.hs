{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}

module Handler
  ( apiHandler
  ) where

import API (Submit, API, Register, Lookup)
import App (runQuery, App)
import Control.Monad.Catch (MonadMask)
import Control.Monad.Except (MonadError)
import Control.Monad.IO.Class (MonadIO)
import Control.Monad.Reader.Class (MonadReader)
import Data.Functor (void)
import Data.Generics.Labels ()
import Database.Esqueleto
import Lens.Micro.Extras (view)
import Prelude hiding (lookup)
import Servant (ServerT)
import Servant (err404)
import Servant (err500, ServerError(..), throwError, (:<|>)(..))
import Servant.API (NoContent(..))
import Submit (runTests)
import qualified Database.Persist as Persistent
import qualified Db.Schema as Db
import qualified Db.Task as Db
import qualified Db.User as Db

apiHandler :: (MonadMask m, MonadError ServerError m, MonadIO m, MonadReader App m) => ServerT API m
apiHandler =
  register :<|>
  lookup :<|>
  submit

register :: (MonadIO m, MonadReader App m) => ServerT Register m
register user = do
  void $ runQuery $ Persistent.insert $ Db.fromUser user
  pure NoContent

lookup :: (MonadError ServerError m, MonadIO m, MonadReader App m) => ServerT Lookup m
lookup name = do
  found <- runQuery $ getBy $ Db.UniqueUsername name
  case found of
    Nothing -> throwError $ err404
    Just user -> pure $ Db.toUser $ entityVal user

submit :: (MonadMask m, MonadIO m, MonadError ServerError m, MonadReader App m) => ServerT Submit m
submit submission  = do
  mtask <- runQuery $ Persistent.get $ view #task submission
  case mtask of
    Nothing -> throwError $ err404 {errBody = "There is no such task."}
    Just task -> maybe (throwError err500) pure =<< runTests (Db.toTask task) (view #code submission)
