class PostsController < ApplicationController
  before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]

  def index
    @topic = Topic.includes(:posts).friendly.find(params[:topic_id])
    # @posts = @topic.posts.order("created_at DESC")
    @posts = Post.all
    if params[:search]
      @posts = Post.search(params[:search]).order("created_at DESC")
    else
      @posts = Post.all.order('created_at DESC')
    end
  end

  def new
    @topic = Topic.friendly.find(params[:topic_id])
    @post = Post.new
  end

  def create
    @topic = Topic.friendly.find(params[:topic_id])
    @post = current_user.posts.build(post_params.merge(topic_id: params[:topic_id]))

    if @post.save
      flash[:success] = "You've created a new post."
      redirect_to topic_posts_path(@topic)
    else
      flash[:danger] = @post.errors.full_messages
      redirect_to new_topic_post_path(@topic)
    end
  end

  def edit
    @post = Post.friendly.find(params[:id])
    @topic = @post.topic
    authorize @post
  end

  def update

    @post = Post.friendly.find(params[:id])
    @topic = @post.topic
    authorize @post
    if @post.update(post_params)
      redirect_to topic_posts_path(@topic)
    else
      redirect_to edit_topic_post_path(@topic, @post)
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @topic = @post.topic
    authorize @post
    if @post.destroy
      redirect_to topic_posts_path(@topic)
    end
  end

  private

  def post_params
    params.require(:post).permit(:image, :title, :body)
  end
end
