$(document).ready(function() {
  window.nestedFormEvents.insertFields = function(content, assoc, link) {
    return $('#groups').append($(content));
  }
});
