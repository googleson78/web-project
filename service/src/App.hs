{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE FlexibleContexts #-}

module App
  ( App(..)
  , runQuery
  ) where

import Control.Concurrent (readMVar, MVar)
import Database.Persist.Sql (runSqlPool, SqlBackend)
import Data.Pool (Pool)
import Control.Monad.Reader.Class (MonadReader(..))
import Control.Monad.IO.Class (MonadIO(..))
import Control.Monad.Reader (ReaderT)

data App = App
  { db :: MVar (Pool SqlBackend)
  }

runQuery :: (MonadIO m, MonadReader App m) => ReaderT SqlBackend IO a -> m a
runQuery query = do
  pool <- liftIO . readMVar . db =<< ask
  liftIO $ runSqlPool query pool
