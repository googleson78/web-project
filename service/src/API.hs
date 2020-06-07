{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}

module API
  ( API, api
  , Register, Lookup
  ) where

import Data.Text (Text)
import Servant
import User (User(..))

api :: Proxy API
api = Proxy

type API =
  Register :<|> Lookup

type Register = ReqBody '[JSON] User :> PostNoContent

type Lookup = Capture "name" Text :> Get '[JSON] User
