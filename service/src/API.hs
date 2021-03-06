{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}

module API
  ( API, api
  , Login
  , AddTask, GetTasks, GetTask
  , Submit, GetSubmissions
  ) where

import Cookies (Cookies)
import Db.Schema (TaskId)
import Servant
import Submit (ProgramWithResult, Submission, Result)
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
  GetTask :<|>
  AddTask :<|>
  Submit :<|>
  GetSubmissions

type Login = "login" :> ReqBody '[JSON] User :> Post '[PlainText] Token

type GetTasks = "tasks" :> Get '[JSON] [TaskWithId]

type GetTask = "task" :> RequiredQueryParam "taskID" TaskId :> Get '[JSON] Task

type AddTask = "task" :> WithCookies :> ReqBody '[JSON] Task :> Post '[JSON] TaskId

type Submit = "submit" :> WithCookies :> ReqBody '[JSON] Submission :> Post '[JSON] Result

type GetSubmissions = "submissions" :> WithCookies :> RequiredQueryParam "taskID" TaskId :> Get '[JSON] [ProgramWithResult]

type WithCookies = Header "Cookie" Cookies

type RequiredQueryParam sym ty = QueryParam' '[Required, Strict] sym ty
