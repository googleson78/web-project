{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}

module API
  ( API, api
  , Login
  , AddTask, GetTasks
  , Submit
  ) where

import Db.Schema (TaskId)
import Servant
import Submit (Submission, Result)
import Task (Task)
import Token (Token)
import User (User)

api :: Proxy API
api = Proxy

-- | We need to add an \"api\" prefix, so that URIs are consistent for everything (requests, cookies, etc).
type API = "api" :> API'

type API' =
  Login :<|>
  GetTasks :<|>
  AddTask :<|>
  Submit

type Login = "login" :> ReqBody '[JSON] User :> Post '[PlainText] Token

type GetTasks = "task" :> Get '[JSON] [(TaskId, Task)]

type AddTask = "task" :> ReqBody '[JSON] Task :> Post '[JSON] TaskId

type Submit = "submit" :> ReqBody '[JSON] Submission :> Post '[JSON] Result
