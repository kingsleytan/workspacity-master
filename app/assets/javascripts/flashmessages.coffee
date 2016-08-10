flashMessagesFunctions = () ->

  clearFlashMessages = () ->
    setTimeout( ()->
      $('.flash-messages').addClass('fadeOut')
    , 2000)
    setTimeout( ()->
      $('#flash-messages-container').html("")
    , 4000)

  if $('.flash-messages').length > 0
    clearFlashMessages()

$(document).on 'turbolinks:load', flashMessagesFunctions
