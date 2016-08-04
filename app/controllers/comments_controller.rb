class CommentsController < ApplicationController

  def index
    @comments = Comment.all.order(created_at: :desc)
  end

  def show
    @comment = Comment.find_by(id: params[:id])

  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      redirect_to comments_path
    else
      render new_comment_path
    end
  end

  def edit
     @comment = Comment.find_by(id: params[:id])
  end

  def update
    @comment = Comment.find_by(id: params[:id])

    if @comment.update(comment_params)
      redirect_to comment_path(@comment)
    else
      redirect_to edit_comment_path(@comment)
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    if @comment.destroy
      redirect_to comments_path
    else
      redirect_to comment_path(@comment)
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:title, :description)
    end
end
