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

type API =
  Register :<|>
  Lookup :<|>
  GetTasks :<|>
  AddTask :<|>
  Submit

type Register = ReqBody '[JSON] User :> PostNoContent

type Lookup = Capture "name" Text :> Get '[JSON] User

type GetTasks = "task" :> Get '[JSON] [(TaskId, Task)]

type AddTask = "task" :> ReqBody '[JSON] Task :> Post '[JSON] TaskId

type Submit = "submit" :> ReqBody '[JSON] Submission :> Post '[JSON] Result
