import { postApiTask } from './queries.js'

function addTask() {
  // task should be a json object - see the correspoding haskell datatype Task for more information
  const task = {}
  task.name = document.getElementById('name').value
  task.description = document.getElementById('description').value
  task.language = document.getElementById('language').value // TODO: CHANGE WHEN MORE LANGUAGES ARE ADDED!
  task.tests = document.getElementById('tests').value
  task.expectedFilename = document.getElementById('expected-filename').value
  postApiTask(
    '',
    task,
    (id) => {},
    (err) => console.log(err),
  )
}

window.addTask = addTask
