{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE BlockArguments #-}

module Handler
  ( apiHandler
  ) where

import Prelude hiding (lookup)
import API (API, Register, Lookup)
import App (runQuery, App)
import Control.Monad.Reader.Class (MonadReader)
import Servant (throwError, (:<|>)(..))
import Servant (ServerT)
import qualified Db.Schema as Db
import qualified Db.User as Db
import qualified Database.Persist as Persistent
import Control.Monad.IO.Class (MonadIO)
import Servant.API (NoContent(..))
import Database.Esqueleto
import Servant (err404)
import Control.Monad.Except (MonadError)
import Servant (ServerError)
import Data.Functor (void)

apiHandler :: (MonadError ServerError m, MonadIO m, MonadReader App m) => ServerT API m
apiHandler = register :<|> lookup

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
