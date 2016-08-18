class CommentsController < ApplicationController
  respond_to :js

  before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]

  def index
    @post = Post.includes(:comments).find_by(slug: params[:post_id])
    @topic = @post.topic
    @comments = @post.comments
    @comment = Comment.new
  end

  def create
    @post = Post.find_by(slug: params[:post_id])
    @topic = @post.topic
    @comment = current_user.comments.build(comment_params.merge(post_id: @post.id))
    @new_comment = Comment.new
    authorize @comment

    if @comment.save
      CommentBroadcastJob.set(wait: 0.1.seconds).perform_later("create", @comment)
      flash.now[:success] = "Comment created"
    else
      flash.now[:danger] = @comment.errors.full_messages
    end
  end

  def edit

    @post = Post.find_by(slug: params[:post_id])
    @topic = @post.topic
    @comment = Comment.find_by(id: params[:id])
    authorize @comment
  end

  def update

    @post = Post.find_by(slug: params[:post_id])
    @topic = @post.topic
    @comment = Comment.find_by(id: params[:id])
    authorize @comment
    if @comment.update(comment_params)
      flash.now[:success] = "You've updated your comment."
      CommentBroadcastJob.perform_later("update", @comment)
    else
      flash.now[:danger] = @comment.errors.full_messages
    end
  end

  def destroy
    @post = Post.find_by(slug: params[:post_id])
    @topic = @post.topic
    @comment = Comment.find_by(id: params[:id])
    authorize @comment

    if @comment.destroy
      flash.now[:danger] = "You've deleted your comment."
      CommentBroadcastJob.perform_now("destroy", @comment)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:image, :body)
  end
end
