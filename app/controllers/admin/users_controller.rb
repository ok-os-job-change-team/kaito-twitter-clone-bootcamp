module Admin
  # Controller for managing users by administrators.
  class UsersController < ApplicationController
    before_action :check_admin

    # GET /admin/users
    def index
      @users = User.all
    end

    # DELETE /admin/users/:id
    def destroy
      @user = User.find(params[:id])
      if @user.destroy
        flash[:notice] = '削除しました'
        redirect_to admin_users_path
      else
        flash[:alert] = '削除に失敗しました'
        render admin_users_path
      end
    end
  end
end
