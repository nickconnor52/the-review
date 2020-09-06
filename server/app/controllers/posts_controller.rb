class PostsController < ApplicationController
  before_action :create_post, only: [:create]

  def index
    posts = Post.all.order :created_at

    render :json => posts
  end

  def create
    render :json => @post
  end

  def update
    post = Post.new()

    render :json => post
  end

  private
  def create_post
    @user = User.find_by(role: 'system_admin')
    @post = Post.new(post_params)
    @post.user = @user
    @post.save!
  end

  def post_params
    params.permit(:title, :content)
  end
end
