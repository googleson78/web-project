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
        if (!isBlank(res.resultOutput)) {
          document.getElementById("output").className = "visible"
          document.getElementById("output").innerHTML = res.resultOutput
        } else {
          document.getElementById("output").className = "invisible"
        }

        if (!isBlank(res.resultError)) {
          document.getElementById("errors").className = "visible"
          document.getElementById("errors").innerHTML = res.resultError
        } else {
          document.getElementById("errors").className = "invisible"
        }
      },
      (err) => document.getElementById("errors").innerHTML = err
    )
}

function isBlank(str) {
    return (!str || /^\s*$/.test(str));
}

getTask()

window.submitTask = submitTask;
