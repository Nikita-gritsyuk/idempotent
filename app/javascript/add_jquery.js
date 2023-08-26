import jquery from 'jquery'
window.jQuery = jquery
window.$ = jquery

$(document).ready(function() {
  $("form").submit(function(event) {
    event.preventDefault();
    var form = $(this);
    var url = form.attr('action');
    var method = form.attr('method');
    var data = form.serialize();
    $.ajax({
      url: url,
      type: method,
      data: data,
      success: function(response) {
        $('#response').html("<p>" + JSON.stringify(response) + "</p>");
      },
    }).fail(function(response) {
      $('#response').html('<p style="color:red">' + response.responseText + '</p>');
    })
  });
});
