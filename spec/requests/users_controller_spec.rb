RSpec.describe UsersController, type: :request do
  describe 'GET /users' do
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user, name: 'hoge_user', email: 'hoge@example.com') }

    context 'ログインしているかつ、正常な時' do
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      it 'リクエストが成功し、アカウント名が表示されること' do
        aggregate_failures do
          get users_path
          expect(response.status).to eq 200
          expect(response.body).to include user.name
          expect(response.body).to include another_user.name
        end
      end
    end

    context 'ログインしていないとき' do
      it 'ログインページにリダイレクトすること' do
        aggregate_failures do
          get users_path
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to login_path
        end
      end
    end
  end

  describe 'GET /users/:id' do
    let!(:user) { create(:user) }

    context 'ログインしているかつ、正常な場合' do
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      it 'リクエストが成功し、アカウント名が表示されること' do
        aggregate_failures do
          get user_path(user)
          expect(response.status).to eq 200
          expect(response.body).to include user.name
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトすること' do
        aggregate_failures do
          get user_path(user)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to login_path
        end
      end
    end
  end

  describe 'POST /users' do
    context 'ユーザーの作成が正常に実行される場合' do
      it 'ユーザー登録に成功すること' do
        expect do
          post users_path, params: { user: { name: 'test_user', email: 'sample@example.com', password: 'sample_password' } }
        end.to change(User, :count).by(1)
      end
    end

    context 'ユーザーの作成に失敗し、バリデーションエラーとなる場合' do
      it 'ユーザー登録に失敗すること' do
        expect do
          post users_path, params: { user: { name: '', email: '', password: '' } }
        end.to change(User, :count).by(0)
      end
    end
  end

  describe 'DELETE /users' do
    context 'ログインユーザーと同じユーザーのユーザー情報を削除する場合' do
      let!(:user) { create(:user) }

      before do
        post login_path, params: { email: user.email, password: 'sample_password' }
      end

      it 'ユーザー削除に成功すること' do
        expect do
          delete user_path(user.id)
        end.to change(User, :count).by(-1)
      end
    end

    context 'ログインユーザーと異なるユーザーのユーザー情報を変更する場合' do
      let!(:user) { create(:user) }
      let!(:another_user) { create(:user, name: 'hoge_user', email: 'hoge@example.com') }

      before do
        post login_path, params: { email: another_user.email, password: 'sample_password' }
      end

      it 'ユーザーリストページにリダイレクトすること' do
        aggregate_failures do
          delete user_path(user.id)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to users_path
        end
      end
    end
  end

  describe 'PUT /users/:id' do
    context 'ログインユーザーと同じユーザーのユーザー情報を変更し、なおかつ入力情報が正常な場合' do
      let!(:user) { create(:user) }

      before do
        post login_path, params: { email: user.email, password: 'sample_password' }
      end

      it 'プロフィールの変更に成功すること' do
        aggregate_failures do
          put user_path(user.id), params: { user: { name: 'new_name', email: 'new_sample@example.com', password: 'new_sample_password' } }
          expect(user.reload.name).to eq 'new_name'
          expect(user.reload.email).to eq 'new_sample@example.com'
        end
      end
    end

    context 'ログインユーザーと同じユーザーのユーザー情報を変更し、入力情報が異常で、バリデーションエラーとなる場合' do
      let!(:user) { create(:user) }

      before do
        post login_path, params: { email: user.email, password: 'sample_password' }
      end

      it 'プロフィールの変更に失敗すること' do
        aggregate_failures do
          put user_path(user.id), params: { user: { name: '', email: '', password: '' } }
          expect(user.reload.name).to eq user.name
          expect(user.reload.email).to eq user.email
          expect(response.body).to include '変更に失敗しました'
        end
      end
    end

    context 'ログインユーザーと異なるユーザーのユーザー情報を変更する場合' do
      let!(:user) { create(:user) }
      let!(:another_user) { create(:user, name: 'hoge_user', email: 'hoge@example.com') }

      before do
        post login_path, params: { email: another_user.email, password: 'sample_password' }
      end

      it 'ユーザーリストページにリダイレクトすること' do
        aggregate_failures do
          put user_path(user.id), params: { user: { name: 'new_name', email: 'new_sample@example.com', password: 'new_sample_password' } }
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to users_path
        end
      end
    end
  end

  describe 'GET users/:id/edit' do
    context 'ログインユーザーと同じユーザーのユーザー情報を変更する場合' do
      let!(:user) { create(:user) }

      before do
        post login_path, params: { email: user.email, password: 'sample_password' }
      end

      it 'アカウント編集ページに遷移すること' do
        aggregate_failures do
          get edit_user_path(user.id)
          expect(response.status).to eq 200
          expect(response.body).to include 'アカウント編集'
        end
      end
    end

    context 'ログインユーザーと異なるユーザーのユーザー情報を変更する場合' do
      let!(:user) { create(:user) }
      let!(:another_user) { create(:user, name: 'hoge_user', email: 'hoge@example.com') }

      before do
        post login_path, params: { email: another_user.email, password: 'sample_password' }
      end

      it 'ユーザーリストページにリダイレクトすること' do
        aggregate_failures do
          get edit_user_path(user.id)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to users_path
        end
      end
    end
  end

  describe 'GET users/:id/follows' do
    context 'ログインしているとき' do
      let!(:user) { create(:user) }

      before do
        post login_path, params: { email: user.email, password: 'sample_password' }
      end

      it 'フォローリストページに遷移すること' do
        aggregate_failures do
          get follows_user_path(user.id)
          expect(response.status).to eq 200
          expect(response.body).to include 'フォローリスト'
        end
      end
    end

    context 'ログインしていないとき' do
      let!(:user) { create(:user) }

      it 'ログインページにリダイレクトすること' do
        aggregate_failures do
          get follows_user_path(user.id)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to login_path
        end
      end
    end
  end

  describe 'GET users/:id/followers' do
    context 'ログインしているとき' do
      let!(:user) { create(:user) }

      before do
        post login_path, params: { email: user.email, password: 'sample_password' }
      end

      it 'フォロワーリストページに遷移すること' do
        aggregate_failures do
          get followers_user_path(user.id)
          expect(response.status).to eq 200
          expect(response.body).to include 'フォロワーリスト'
        end
      end
    end

    context 'ログインしていないとき' do
      let!(:user) { create(:user) }

      it 'ログインページにリダイレクトすること' do
        aggregate_failures do
          get followers_user_path(user.id)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to login_path
        end
      end
    end
  end
end
