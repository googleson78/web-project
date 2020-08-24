import { getApiTask, postApiSubmit } from './queries.js'

const url = new URL(window.location.href)
const taskID = url.searchParams.get('taskID')

function getTask() {
    getApiTask(
      taskID,
      (task) =>
        (
        document.getElementById('task').innerHTML =
            `<div class="panel panel-default">
                <div class="panel-heading"><a href="#">${task.name}</a></div>
                <div class="panel-body">
                    <p>Language: ${task.language}</p>
                    <p>Description: ${task.description}</p>
                </div>
            </div>`
    ),
      (err) => document.getElementById('task').innerHTML =
        `<div class="panel panel-danger">
            <div class="panel-heading">An Error Occured</div>
            <div class="panel-body">
                <p>Error: ${err}</p>
            </div>
        </div>`,
    );
}

function submitTask() {
    let code = document.getElementById("problem").value
    postApiSubmit(
      {task: +taskID,code: code},
      (res) => {
        document.getElementById("output").innerHTML = res.resultOutput
        document.getElementById("errors").innerHTML = res.resultError
      },
      (err) => document.getElementById("errors").innerHTML = err
    )
}

getTask()

window.submitTask = submitTask;
