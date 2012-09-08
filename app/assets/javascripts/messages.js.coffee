# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

  $ ->
    $("div#replying").hide();
    $('button#buttonreply').click ->
       $("div#replying").show();
       $(this).hide()
       $("#message_content").focus()
       $("div#replying").scrollIntoView(true);

