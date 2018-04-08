class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers, :likings, :likers]
  
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order('created_at DESC').page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = "ユーザを登録しました"
      redirect_to @user #@userは上記で作られたインスタンスなので、URL生成メソッドにインスタンスを指定すると、強制的に、showアクションに飛ぶようになっている
    else
      flash.now[:danger] = "ユーザ登録に失敗しました"
      render :new
    end
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  def likings
    @user =  User.find(params[:id])
    @likings = @user.likings.page(params[:page])
    counts(@user)
  end
  
  def likers
    @user = User.find(params[:id])
    @likers = @user.likers.page(params[:page])
    counts(@user)
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
