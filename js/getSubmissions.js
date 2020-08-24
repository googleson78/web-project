import { getApiSubmissions } from './queries.js'

const url = new URL(window.location.href)
const taskID = url.searchParams.get('taskID')

function generateHTMLList(submissions) {
  let res = ''
  if (submissions.length > 0) {
    let index = 0
    for (let item of submissions) {
      index++;
      const { program, result } = item
      if (result.passed) {
        res += `
              <div class="panel panel-success">
              <div class="panel-heading">(${index}) PASSED | TASK ID: ${taskID}</div>
              <div class="panel-body">
                <p>code:</p>
                <pre>${program}</pre>
                <p>result</p>
                <pre>${result.resultOutput}</pre>
              </div>
              </div>`
      } else {
        res += `
        <div class="panel panel-warning">
        <div class="panel-heading">(${index}) NOT PASSED | TASK ID: ${taskID}</div>
        <div class="panel-body">
          <p>code:</p>
          <pre>${program}</pre>
          <p>result</p>
          <pre>${result.resultError}</pre>
        </div>
        </div>`
      }
    }
  } else {
    res = `<div class="panel panel-default">
              <div class="panel-heading">No submissions :(</div>
              <div class="panel-body">
                but you can upload one!
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


function getSubmissions() {
  getApiSubmissions(
    taskID,
    (data) => document.getElementById('submissions').innerHTML = generateHTMLList(data),
    (err) => document.getElementById('submissions').innerHTML = generateHTMLError(err),
  )
}

getSubmissions();
