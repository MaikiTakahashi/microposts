class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :followings, :followers, :lovings]
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at: :desc)
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to root_path , notice: 'プロフィールを編集しました'
    else
      render 'edit'
    end
  end
  
  def set_user
    @user = User.find(params[:id])
  end

  def followings
    @users = @user.following_users
    render 'show_follow'
  end

  def followers
    @users = @user.follower_users
    render 'show_follow'
  end
  
  def lovings
    @microposts = @user.loving_microposts
    render 'show_love'
  end  
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :live, :introduction)
  end

  def correct_user
    redirect_to(root_url) unless @user == current_user
  end

end