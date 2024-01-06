class RelationshipsController < ApplicationController
  before_action :check_logged_in, only: %i[create destroy]

  # POST /users/:user_id/relationships
  def create
    follow = current_user.active_relationships.build(follower_id: params[:user_id])
    follow.save
    redirect_to users_path
  end

  # DELETE /users/:user_id/relationships
  def destroy
    follow = current_user.active_relationships.find_by(follower_id: params[:user_id])
    follow.destroy
    redirect_to users_path
  end
end
