class PostsChannel < ApplicationCable::Channel

  def subscribed
    stream_from "posts_channel"
    logger.add_tags 'ActionCable', "User connected to posts channel"
  end

  def unsubscribed
  end
end
