class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  def create
    micropost = Micropost.find(params[:micropost])
    current_user.like(micropost)
    flash[:success] = "お気に入りに登録しました"
    redirect_to root_url
  end

  def destroy
     micropost = Micropost.find(params[:micropost])
    current_user.unlike(micropost)
    flash[:success] = "お気に入りから外しました"
    redirect_to root_url
  end
end
