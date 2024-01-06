class UsersController < ApplicationController
  before_action :check_logged_in, only: %i[index show follows followers]
  before_action -> { check_edit_authority(params[:id].to_i) }, only: %i[edit update destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
    @tweets = @user.tweets
    @favorite_tweets = @user.favorite_tweets
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = '登録に成功しました'
      redirect_to '/users'
    else
      flash.now[:alert] = '登録に失敗しました'
      render :new
    end
  end

  # DELETE /users/:id
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = '削除しました'
      redirect_to '/users'
    else
      flash[:alert] = '削除に失敗しました'
      redirect_to '/users'
    end
  end

  # GET /users/:id/edit
  def edit
    @user = User.find(params[:id])
  end

  # PUT /users/:id
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = '変更に成功しました'
      redirect_to '/users'
    else
      flash.now[:alert] = '変更に失敗しました'
      render :edit
    end
  end

  # GET /users/:id/follows
  def follows
    user = User.find(params[:id])
    @users = user.followings
  end

  # GET /users/:id/followers
  def followers
    user = User.find(params[:id])
    @users = user.followers
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
    # require(:user)はuser内に指定の値が存在するかチェック
    # permit(:email, :password)はemailとpasswordがあるかチェック
    # 結果として、user内にあるemailとpasswordだけを取得
  end
end
