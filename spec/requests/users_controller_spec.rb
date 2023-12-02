RSpec.describe UsersController, type: :request do
  describe 'GET /users' do
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user, email:'yukko@example.com') }

    context 'ログインしているかつ、正常な時' do
      before do
        post login_path, params: { email: user.email, password: 'sample_password' }
      end

      it 'リクエストが成功し、ユーザー名が表示されること' do
        aggregate_failures do
          get users_path
          expect(response.status).to eq 200
          expect(response.body).to include user.email
          expect(response.body).to include another_user.email
        end
      end
    end

    context 'ログインしていないとき' do
      it 'ログインページにリダイレクトすること' do
        aggregate_failures do
          get users_path
          expect(response).to have_http_status(302)
          expect(response).to redirect_to login_path
        end
      end
    end
  end

  describe 'GET /users/:id' do
    let(:user) { create(:user) }

    context 'ログインしているかつ、正常な場合' do
      before do
        post login_path, params: { email: user.email, password: 'sample_password' }
      end

      it 'リクエストが成功し、ユーザー名が表示されること' do
        aggregate_failures do
          get user_path(user)
          expect(response.status).to eq 200
          expect(response.body).to include 'sample@example.com'
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトすること' do
        aggregate_failures do
          get user_path(user)
          expect(response).to have_http_status(302)
          expect(response).to redirect_to login_path
        end
      end
    end
  end

  describe 'POST /users' do
    context 'ユーザーの作成が正常に実行される場合' do
      it 'ユーザー登録に成功すること' do
        expect{
          post users_path, params: { user: { email: 'sample@example.com', password: 'sample_password' } }
        }.to change(User, :count).by(1)
      end
    end

    context 'ユーザーの作成に失敗し、バリデーションエラーとなる場合' do
      it 'ユーザー登録に失敗すること' do
        expect{
          post users_path, params: { user: { email: '', password: '' } }
        }.to change(User, :count).by(0)
      end
    end
  end

  describe 'DELETE /users' do
    context '存在するユーザーを削除する場合' do
      let!(:user) { create(:user) }
      it 'ユーザー削除に成功すること' do
        expect{
          delete user_path(user.id)
        }.to change(User, :count).by(-1)
      end
    end
    
    context '存在しないユーザーを削除する場合' do
      it 'ユーザー削除に失敗すること' do
        expect{
          delete user_path(0)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'PUT /users/:id' do
    context 'ログインユーザーと同じユーザーのユーザー情報を変更し、なおかつemailとpasswordが正常な場合' do
      let!(:user) { create(:user) }

      before do
        post login_path, params: { email: user.email, password: 'sample_password' }
      end

      it 'プロフィールの変更に成功すること' do
        aggregate_failures do
          put user_path(user.id), params: { user: { email: 'new_sample@example.com', password: 'new_sample_password' } }
          expect(user.reload.email).to eq 'new_sample@example.com'
          # expect(user.reload.password).to eq 'new_sample_password'
        end
      end
    end
    
    context 'emailとpasswordが異常で、バリデーションエラーとなる場合' do
      let!(:user) { create(:user) }

      before do
        post login_path, params: { email: user.email, password: 'sample_password' }
      end

      it 'プロフィールの変更に失敗すること' do
        aggregate_failures do
          put user_path(user.id), params: { user: { email: '', password: '' } }
          expect(user.reload.email).to eq 'sample@example.com'
          expect(user.reload.password).to eq 'sample_password'
          expect(response.body).to include '変更に失敗しました'
        end
      end
    end

    context 'ログインユーザーと異なるユーザーのユーザー情報を変更する場合' do
      before do
        post login_path, params: { email: user.email, password: 'sample_password' }
      end

      let!(:user) { create(:user) }

      it 'ユーザー一覧ページにリダイレクトすること' do
        aggregate_failures do
          put user_path(user.id), params: { user: { email: 'new_sample@example.com', password: 'new_sample_password' } }
          expect(response).to have_http_status(302)
          expect(response).to redirect_to users_path       
        end        
      end
    end
  end

  describe 'GET users/:id/edit' do
    let!(:user) { create(:user) }

    context 'ログインユーザーと同じユーザーのユーザー情報を変更する場合' do
      pending
    end

    context 'ログインユーザーと異なるユーザーのユーザー情報を変更する場合' do
      pending
    end
  end
end