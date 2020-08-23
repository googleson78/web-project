{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}

module API
  ( API, api
  , Login
  , AddTask, GetTasks
  , Submit
  ) where

import Cookies (Cookies)
import Db.Schema (TaskId)
import Servant
import Submit (Submission, Result)
import Task (Task, TaskWithId)
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

type GetTasks = "task" :> Get '[JSON] [TaskWithId]

type AddTask = "task" :> WithCookies :> ReqBody '[JSON] Task :> Post '[JSON] TaskId

type Submit = "submit" :> WithCookies :> ReqBody '[JSON] Submission :> Post '[JSON] Result

type WithCookies = Header "Cookie" Cookies
