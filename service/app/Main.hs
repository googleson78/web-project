{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE BlockArguments #-}

module Main where

import Handler
import Servant.Server (Handler, hoistServer, serve)
import API (api)
import Network.Wai.Handler.Warp (run)
import Data.Pool (Pool)
import Database.Persist.Sql (SqlBackend)
import Control.Monad.Reader (runReaderT, ReaderT)
import App (App(..))
import Control.Monad.IO.Class (MonadIO(liftIO))
import Control.Concurrent.MVar (newMVar)
import Database.Persist.MySQL (withMySQLPool, withMySQLConn, ConnectInfo(..))
import Database.MySQL.Base (Option(Reconnect))
import Db.Schema (migrateAll)
import Database.Persist.Sql (runMigration)
import Control.Monad.Logger (NoLoggingT(..), runNoLoggingT)
import Database.MySQL.Base (defaultConnectInfo)
import qualified Data.HashMap.Strict as Map

main :: IO ()
main = do
  runNoLoggingT $ withMySQLConn connectInfo $ runReaderT $ runMigration migrateAll

  tokensMVar <- liftIO $ newMVar Map.empty
  let
    runServer :: Pool SqlBackend -> ReaderT App Handler a -> Handler a
    runServer pool act = do
      runReaderT act $ App pool tokensMVar

  runNoLoggingT $ withMySQLPool connectInfo 100 \pool ->
    liftIO $ run 3000 $ serve api $ hoistServer api (runServer pool) apiHandler

connectInfo :: ConnectInfo
connectInfo =
  defaultConnectInfo
    { connectHost = "localhost"
    , connectPort = 3306
    , connectUser = "root"
    , connectPassword = ""
    , connectDatabase = "db"
    , connectOptions = Reconnect True : connectOptions defaultConnectInfo
    }
