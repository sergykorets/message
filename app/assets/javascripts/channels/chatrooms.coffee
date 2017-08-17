App.chatrooms = App.cable.subscriptions.create "ChatroomsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    active_chatroom = $("[data-behavior='messages'][data-chatroom-id='#{data.chatroom_id}']")

    if active_chatroom.length > 0
      if document.hidden
        if $(".strike").length == 0
          active_chatroom.prepend("<div class='strike'><span>Unread</span></div>")
        if Notification.permission == "granted"
          new Notification(data.name, {body: data.body})
      else
        App.last_read.update(data.chatroom_id)
      active_chatroom.prepend(data.message)
    else
      if Notification.permission == "granted"
        new Notification(data.name, {body: data.body})
      $("[data-behavior='chatroom-link'][data-chatroom-id='#{data.chatroom_id}']").css("color", "red")
      $(".inbox").css("background-color", "red")

  send_message: (chatroom_id, message) ->
    @perform "send_message", {chatroom_id: chatroom_id, body: message}