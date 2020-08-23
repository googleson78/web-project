import { getApiTask } from './queries.js'

function generateHTMLList(tasks) {
  let res = ''
  if (tasks.length > 0) {
    for (let item of tasks) {
      const task = item.task
      res += `
        <div class="panel panel-default">
          <div class="panel-heading"><a href="#">${task.name}</a></div>
          <div class="panel-body">
            <p>Language: ${task.language}</p>
            <p>Description: ${task.description}</p>
          </div>
        </div>`
    }
  } else {
    res = `<div class="panel panel-default">
            <div class="panel-heading">No new tasks :(</div>
            <div class="panel-body">
              later someone may upload one
            </div>
          </div>`
  }
  return res
}

function generateHTMLError(err) {
  return `<div class="panel panel-danger">
            <div class="panel-heading">An Error Occured</div>
            <div class="panel-body">
              <p>Error: ${err}</p>
            </div>
          </div>`
}

function getTasks() {
  getApiTask(
    (tasks) =>
      (document.getElementById('tasks').innerHTML = generateHTMLList(tasks)),
    (err) =>
      (document.getElementById('tasks').innerHTML = generateHTMLError(err)),
  )
}

getTasks()
