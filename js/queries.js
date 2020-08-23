const getApiTask = function(backendUrl, onSuccess, onError) {
    let xhr = new XMLHttpRequest();
    xhr.open('GET', backendUrl + '/api/task', true);
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.onreadystatechange = function () {
      let res = null;
      if (xhr.readyState === 4) {
        if (xhr.status === 204 || xhr.status === 205) {
          onSuccess();
        } else if (xhr.status >= 200 && xhr.status < 300) {
          try { res = JSON.parse(xhr.responseText); } catch (e) { onError(e); }
          if (res) onSuccess(res);
        } else {
          try { res = JSON.parse(xhr.responseText); } catch (e) { onError(e); }
          if (res) onError(res);
        }
      }
    };
    xhr.send(null);
  };
  
  const postApiTask = function(backendUrl, body, onSuccess, onError) {
    let xhr = new XMLHttpRequest();
    xhr.open('POST', backendUrl + '/api/task', true);
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.onreadystatechange = function () {
      let res = null;
      if (xhr.readyState === 4) {
        if (xhr.status === 204 || xhr.status === 205) {
          onSuccess();
        } else if (xhr.status >= 200 && xhr.status < 300) {
          try { res = JSON.parse(xhr.responseText); } catch (e) { onError(e); }
          if (res) onSuccess(res);
        } else {
          try { res = JSON.parse(xhr.responseText); } catch (e) { onError(e); }
          if (res) onError(res);
        }
      }
    };
    xhr.send(JSON.stringify(body));
  };
  
  const postApiSubmit = function(backendUrl, body, onSuccess, onError) {
    let xhr = new XMLHttpRequest();
    xhr.open('POST', backendUrl + '/api/submit', true);
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.onreadystatechange = function () {
      let res = null;
      if (xhr.readyState === 4) {
        if (xhr.status === 204 || xhr.status === 205) {
          onSuccess();
        } else if (xhr.status >= 200 && xhr.status < 300) {
          try { res = JSON.parse(xhr.responseText); } catch (e) { onError(e); }
          if (res) onSuccess(res);
        } else {
          try { res = JSON.parse(xhr.responseText); } catch (e) { onError(e); }
          if (res) onError(res);
        }
      }
    };
    xhr.send(JSON.stringify(body));
  };
  
  export {getApiTask};