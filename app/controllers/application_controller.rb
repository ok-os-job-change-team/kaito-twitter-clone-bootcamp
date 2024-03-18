class ApplicationController < ActionController::Base
  helper_method :current_user

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_not_found
    render template: 'errors/error_404', status: :not_found, layout: 'application'
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def check_logged_in
    return unless current_user.nil?

    flash[:alert] = 'ログインしてください'
    redirect_to login_path
  end

  def check_edit_authority(user_id)
    return if current_user&.id == user_id

    flash[:alert] = '自分以外のユーザーは編集・削除できません'
    redirect_to users_path
  end

  def check_admin
    return if current_user.admin?

    flash[:alert] = '権限がありません'
    redirect_to users_path
  end
end
