class VotesChannel < ApplicationCable::Channel

  def subscribed
    stream_from "votes_channel"
    logger.add_tags 'ActionCable', "User connected to votes channel"
  end

  def unsubscribed
  end
end
