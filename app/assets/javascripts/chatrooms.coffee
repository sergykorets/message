handleClickChange = ->
  $strike = $(".strike")
  if $strike.length > 0
    chatroom_id = $("[data-behavior='messages']").data("chatroom-id")
    App.last_read.update(chatroom_id)
    $strike.remove()
    $("[data-behavior='chatroom-link'][data-chatroom-id='#{chatroom_id}']").css("color", "#0275d8")

$(document).on 'ready turbolinks:load', ->
  $(document).on "click", handleClickChange

  $('#new_message').on "keypress", (e) ->
    if e && e.keyCode == 13
      e.preventDefault()
      $(this).submit()

  $("#new_message").on "submit", (e) ->
    e.preventDefault()

    chatroom_id = $("[data-behavior='messages']").data("chatroom-id")
    body = $("#message_body")
    App.chatrooms.send_message(chatroom_id, body.val())

    body.val("")