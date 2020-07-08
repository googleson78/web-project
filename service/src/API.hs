{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}

module API
  ( API, api
  , Register, Lookup, Submit
  ) where

import Data.Text (Text)
import Servant
import User (User(..))
import Submit (Submission, Result)

api :: Proxy API
api = Proxy

type API =
  Register :<|>
  Lookup :<|>
  Submit

type Register = ReqBody '[JSON] User :> PostNoContent

type Lookup = Capture "name" Text :> Get '[JSON] User

type Submit = "submit" :> ReqBody '[JSON] Submission :> Post '[JSON] Result
