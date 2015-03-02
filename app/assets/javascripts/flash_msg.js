$(document).ajaxError(function(event, request) {
  var msg = request.getResponseHeader('X-Message');
    if (msg) {
      alert(msg);
      $('#errors').append(msg);
      $('#errors').show();
      }

});