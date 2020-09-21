class CommentsController < ApplicationController
  before_action :require_login, only: [:create]
  before_action :create_comment, only: [:create]

  def create
    render :json => @comment, :include => [:author, :child_comments]
  end

  private
  def create_comment
    @comment = Comment.new(comment_params)
    @comment.save!
  end

  def comment_params
    params.permit(:user_id, :body, :post_id)
  end
end
