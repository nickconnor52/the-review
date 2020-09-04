class PostsController < ApplicationController
  def index
    posts = Post.all.order :created_at

    render :json => posts
  end
end
