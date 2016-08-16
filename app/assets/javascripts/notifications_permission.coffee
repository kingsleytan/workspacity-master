notificationPermission = () ->
  Notification.requestPermission()

$(document).on 'turbolinks:load', notificationPermission
