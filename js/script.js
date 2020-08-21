import {getApiTask} from "./queries.js"

alert("This alert box was called with the onload event")

function getTasks() {
  getApiTask
    ( (tasks) => document.getElementById("tasks").innerHTML=JSON.stringify(tasks),
      (err) => alert(err)
    )
}

window.getTasks = getTasks // TODO: don't use globals
