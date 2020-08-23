import { getApiTask } from './queries.js'

function getTasks() {
  getApiTask(
    '',
    (tasks) =>
      (document.getElementById('tasks').innerHTML = JSON.stringify(tasks)),
    (err) => alert(err),
  )
}

window.getTasks = getTasks // TODO: don't use globals
