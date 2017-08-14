$(document).on 'ready turbolinks:load', ->
  $('#message_body').on "keypress", (e) ->
    if(e.which == 13)
      e.preventDefault()
      $(this).closest('form').submit()