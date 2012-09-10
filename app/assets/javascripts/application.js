//= require jquery
//= require jquery-ui
function add_fields(link, association, content) {
 alert("called")
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
 
  $(link).up().insert({
    before: content.replace(regexp, new_id)
  });
}

