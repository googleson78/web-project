import { getApiTask } from './queries.js'

function generateHTMLList(tasks) {
  let res = '';
  for (let item of tasks) {
    const task = item.task;
    res +=
      `
      <div class="panel panel-default">
        <div class="panel-heading"><a href="#">${task.name}</a></div>
        <div class="panel-body">
          <p>Language: ${task.language}</p>
          <p>Description: ${task.description}</p>
        </div>
      </div>`;
  }
  return res;
}

function getTasks() {
  getApiTask(
    '',
    (tasks) =>
      (document.getElementById('tasks').innerHTML
        = generateHTMLList(tasks)
      ),
    (err) => alert(err),
  )
}

getTasks();
