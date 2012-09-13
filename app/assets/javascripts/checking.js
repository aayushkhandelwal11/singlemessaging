$('input[value="Delete Checked"]').click(function() {
    var n = $("input:checkbox:checked").length;
    if (n == 0 ){
      alert("No message is selected")
      return false;
    }
});