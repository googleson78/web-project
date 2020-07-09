{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}

module API
  ( API, api
  , Register, Lookup
  , AddTask, GetTasks
  , Submit
  ) where

import Data.Text (Text)
import Servant
import User (User)
import Task (Task)
import Submit (Submission, Result)
import Db.Schema (TaskId)

api :: Proxy API
api = Proxy

-- | We need to add an \"api\" prefix, so that URIs are consistent for everything (requests, cookies, etc).
type API = "api" :> API'

type API' =
  Register :<|>
  Lookup :<|>
  GetTasks :<|>
  AddTask :<|>
  Submit

type Register = "user" :> ReqBody '[JSON] User :> PostNoContent

type Lookup = "user" :> Capture "name" Text :> Get '[JSON] User

type GetTasks = "task" :> Get '[JSON] [(TaskId, Task)]

type AddTask = "task" :> ReqBody '[JSON] Task :> Post '[JSON] TaskId

type Submit = "submit" :> ReqBody '[JSON] Submission :> Post '[JSON] Result
