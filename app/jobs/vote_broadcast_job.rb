class VoteBroadcastJob < ApplicationJob
  queue_as :default

  def perform(comment)
    ActionCable.server.broadcast 'votes_channel', comment_id: comment.id, value: comment.total_votes
  end
  #
  # private
  #
  # def render_vote_partial(comment)
  #   VotesController.render partial: "comments/vote", locals: { comment_id: comment.id, value: comment.total_votes, comment: comment}
  # end
end
