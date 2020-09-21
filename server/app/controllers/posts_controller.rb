class PostsController < ApplicationController
  before_action :create_post, only: [:create]
  before_action :find_post, only: [:show, :update, :destroy]
  before_action :require_login, only: [:create, :update, :destroy]

  def chatter
    posts = Post.where(post_type: 'chatter').order created_at: :desc

    render :json => posts, :include => [:user]
  end

  def ramblings
    posts = Post.where(post_type: 'rambling').order created_at: :desc

    render :json => posts, :include => [:user]
  end

  def show
    render :json => @post, :include => [
      :user,
      {
        :comments => {
          :include => [:author, :child_comments]
        }
      }

    ]
  end

  def create
    render :json => @post
  end

  def update
    @post.content = post_params[:content]
    @post.summary = post_params[:summary]
    @post.title = post_params[:title] unless post_params[:title].blank?
    @post.save!

    render :json => @post
  end

  def destroy
    successful = @post.destroy

    render :json => { success: successful }
  end

  private
  def create_post
    @user = User.find(params[:user_id])
    @post = Post.new(post_params)
    @post.user = @user
    @post.save!
  end

  def find_post
    @post = Post.find(post_params[:id])
  end

  def post_params
    params.permit(:id, :title, :content, :summary, :post_type)
  end
end
