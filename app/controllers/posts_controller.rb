class PostsController < ApplicationController

  def index
    @topic = Topic.includes(:posts).find_by(id: params[:topic_id])
    @posts = @topic.posts.order("created_at DESC")
  end

  def new
    @topic = Topic.find_by(id: params[:topic_id])
    @post = Post.new
  end

  def create
    @topic = Topic.find_by(id: params[:topic_id])
    @post = Post.new(post_params.merge(topic_id: params[:topic_id]))

    if @post.save
      redirect_to topic_posts_path(@topic)
    else
      redirect_to new_topic_post_path(@topic)
    end
  end

  def edit
     @post = Post.find_by(id: params[:id])
     @topic = @post.topic
  end

  def update
    @topic = Topic.find_by(id: params[:topic_id])
    @post = Post.find_by(id: params[:id])

    if @post.update(post_params)
      redirect_to topic_posts_path(@topic)
    else
      redirect_to edit_topic_post_path(@topic, @post)
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @topic = @post.topic

    if @post.destroy
      redirect_to topic_posts_path(@topic)
    end
  end

  private

    def post_params
      params.require(:post).permit(:title, :body)
    end
end
