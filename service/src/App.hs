{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE FlexibleContexts #-}

module App
  ( App(..)
  , runQuery, getUser, registerNewToken
  ) where

import Control.Concurrent (modifyMVar_, readMVar, MVar)
import Control.Monad.IO.Class (MonadIO(..))
import Control.Monad.Reader (ReaderT)
import Control.Monad.Reader.Class (MonadReader(..))
import Data.HashMap.Strict (HashMap)
import Data.Pool (Pool)
import Database.Persist.Sql (runSqlPool, SqlBackend)
import Token (genToken, Token)
import User (User)
import qualified Data.HashMap.Strict as Map

data App = App
  { db :: Pool SqlBackend
  , tokens :: MVar (HashMap Token User)
  }

runQuery :: (MonadIO m, MonadReader App m) => ReaderT SqlBackend IO a -> m a
runQuery query = do
  pool <- db <$> ask
  liftIO $ runSqlPool query pool

getUser :: (MonadIO m, MonadReader App m) => Token -> m (Maybe User)
getUser token = do
  tokens <- liftIO . readMVar . tokens =<< ask
  pure $ Map.lookup token tokens

registerNewToken :: (MonadIO m, MonadReader App m) => User -> m Token
registerNewToken user = do

  token <- genToken
  tokensMVar <- tokens <$> ask

  liftIO $ modifyMVar_ tokensMVar (pure . Map.insert token user)
  pure token
