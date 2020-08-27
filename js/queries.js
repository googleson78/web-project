var getApiTasks = function(onSuccess, onError) {
  var xhr = new XMLHttpRequest();
  xhr.open('GET', '/api/tasks', true);
  xhr.setRequestHeader('Accept', 'application/json');
  xhr.onreadystatechange = function () {
    var res = null;
    if (xhr.readyState === 4) {
      if (xhr.status === 204 || xhr.status === 205) {
        onSuccess();
      } else if (xhr.status >= 200 && xhr.status < 300) {
        try { res = JSON.parse(xhr.responseText); } catch (e) { onError(e); }
        if (res) onSuccess(res);
      } else {
        if (xhr.responseText) onError(xhr.responseText)
      }
    }
  };
  xhr.send(null);
};

var getApiTask = function(taskID, onSuccess, onError) {
  var xhr = new XMLHttpRequest();
  xhr.open('GET', '/api/task' + '?taskID=' + encodeURIComponent(taskID), true);
  xhr.setRequestHeader('Accept', 'application/json');
  xhr.onreadystatechange = function () {
    var res = null;
    if (xhr.readyState === 4) {
      if (xhr.status === 204 || xhr.status === 205) {
        onSuccess();
      } else if (xhr.status >= 200 && xhr.status < 300) {
        try { res = JSON.parse(xhr.responseText); } catch (e) { onError(e); }
        if (res) onSuccess(res);
      } else {
        if (xhr.responseText) onError(xhr.responseText)
      }
    }
  };
  xhr.send(null);
};

var postApiTask = function(body, onSuccess, onError) {
  var xhr = new XMLHttpRequest();
  xhr.open('POST', '/api/task', true);
  xhr.withCredentials = true;
  xhr.setRequestHeader('Accept', 'application/json');
  xhr.setRequestHeader('Content-Type', 'application/json');
  xhr.onreadystatechange = function () {
    var res = null;
    if (xhr.readyState === 4) {
      if (xhr.status === 204 || xhr.status === 205) {
        onSuccess();
      } else if (xhr.status >= 200 && xhr.status < 300) {
        try { res = JSON.parse(xhr.responseText); } catch (e) { onError(e); }
        if (res) onSuccess(res);
      } else {
        if (xhr.responseText) onError(xhr.responseText)
      }
    }
  };
  xhr.send(JSON.stringify(body));
};

var postApiSubmit = function(body, onSuccess, onError) {
  var xhr = new XMLHttpRequest();
  xhr.open('POST', '/api/submit', true);
  xhr.withCredentials = true;
  xhr.setRequestHeader('Accept', 'application/json');
  xhr.setRequestHeader('Content-Type', 'application/json');
  xhr.onreadystatechange = function () {
    var res = null;
    if (xhr.readyState === 4) {
      if (xhr.status === 204 || xhr.status === 205) {
        onSuccess();
      } else if (xhr.status >= 200 && xhr.status < 300) {
        try { res = JSON.parse(xhr.responseText); } catch (e) { onError(e); }
        if (res) onSuccess(res);
      } else {
        if (xhr.responseText) onError(xhr.responseText)
      }
    }
  };
  xhr.send(JSON.stringify(body));
};

var getApiSubmissions = function(taskID, onSuccess, onError) {
  var xhr = new XMLHttpRequest();
  xhr.open('GET', '/api/submissions' + '?taskID=' + encodeURIComponent(taskID), true);
  xhr.withCredentials = true;
  xhr.setRequestHeader('Accept', 'application/json');
  xhr.onreadystatechange = function () {
    var res = null;
    if (xhr.readyState === 4) {
      if (xhr.status === 204 || xhr.status === 205) {
        onSuccess();
      } else if (xhr.status >= 200 && xhr.status < 300) {
        try { res = JSON.parse(xhr.responseText); } catch (e) { onError(e); }
        if (res) onSuccess(res);
      } else {
        if (xhr.responseText) onError(xhr.responseText)
      }
    }
  };
  xhr.send(null);
};

export { getApiTask, postApiTask, getApiTasks, postApiSubmit, getApiSubmissions }
