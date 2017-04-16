votesChannelFunctions = () ->

  if $('.comments-index').length > 0
    App.posts_channel = App.cable.subscriptions.create {
      channel: "VotesChannel"
    },
    connected: () ->
      console.log("user logged in votes_channel")

    disconnected: () ->
      console.log("user not logged in")

    received: (data) ->
      console.log("vote coming")
      $(".comment[data-id=#{data.comment_id}] .voting-score").html(data.value)


$(document).on 'turbolinks:load', votesChannelFunctions
