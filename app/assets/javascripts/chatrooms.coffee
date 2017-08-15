$(document).on 'ready turbolinks:load', ->
  $('#message_body').on "keypress", (e) ->
    if(e.which == 13)
      e.preventDefault()
      $(this).closest('form').submit()

  $("#new_message").on "submit", (e) ->
    e.preventDefault()

    chatroom_id = $("[data-behavior='messages']").data("chatroom-id")
    body = $("#message_body")
    
    App.chatrooms.send_message(chatroom_id, body.val())

    body.val("")