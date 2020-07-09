import {getApiTask} from "./queries.js"

alert("This alert box was called with the onload event")

function getTasks() {
  getApiTask
    ( (tasks) => alert(tasks.toString()),
      (err) => alert(err.toString())
    )
}

window.getTasks = getTasks // TODO: don't use globals
