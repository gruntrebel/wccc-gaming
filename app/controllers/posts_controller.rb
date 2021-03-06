class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :destroy, :create, :update, :new]
  load_and_authorize_resource :except => [:news_list, :event_list]

def new
  @post = Post.new
end

def index
  @pagi = Post.paginate(:page => params[:page], :per_page => 3, :order => 'created_at desc')
  @events = Post.where("is_event = 'true'").reorder('event_date ASC').take(5)
end

def create
  @post = Post.new(post_params)
  if @post.save
    redirect_to @post
  else
    render 'new'
  end
end

def edit
  @post = Post.find(params[:id])
end

def update
  @post = Post.find(params[:id])

  if @post.update(post_params)
    redirect_to @post
  else
    render 'edit'
  end
end

def destroy
  @post = Post.find(params[:id])
  @post.destroy

  redirect_to posts_path
end

def show
  @post = Post.find(params[:id])
end

def news_list
  @posts = Post.paginate(:page => params[:page], :per_page => 7, :order => 'created_at desc')
end

def event_list
  @events = Post.where("is_event = 'true'").reorder('event_date desc').paginate(:page => params[:page], :per_page => 7)
end

rescue_from CanCan::AccessDenied do |exception|
  redirect_to root_url, :alert => exception.message
end

private
  def post_params
    params.require(:post).permit(:title, :text, :summary, :is_event, :event_date)
  end
end
