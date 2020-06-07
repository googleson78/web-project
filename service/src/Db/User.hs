{-# LANGUAGE 
   RecordWildCards,
   NamedFieldPuns
   #-}

module Db.User
  ( toUser, fromUser
  ) where

import qualified Db.Schema as Db
import User (User(..))

toUser :: Db.User -> User
toUser Db.User {..} =
  User
    { name = userName
    , password = userPassword
    }

fromUser :: User -> Db.User
fromUser User {..} =
  Db.User
    { userName = name
    , userPassword = password
    }
