class RelationshipsLoveController < ApplicationController
  before_action :logged_in_user
  
  def create
    @micropost = Micropost.find(params[:loved_id])
    current_user.love(@micropost)
  end
  
  def destroy
    @micropost = current_user.loving_relationships.find(params[:id]).loved
    current_user.unlove(@micropost)
  end

end
