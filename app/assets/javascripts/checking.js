 var no_of_checkboxes = $("input:checkbox").length ;

 if (no_of_checkboxes <2)
  { $('input[value="Delete Checked"]').hide();
     $('#checkall').hide();
   }

$('#checkall').click(function(){
    $('input:checkbox').attr('checked',this.checked);
});

$('input[value="Delete Checked"]').click(function(){
  var n = $("input:checkbox:checked").length;
  if (n == 0)
  {
    alert("please select a message");
    return false;
  }
});

