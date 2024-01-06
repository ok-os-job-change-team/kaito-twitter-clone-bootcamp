RSpec.describe RelationshipsController, type: :request do
  describe 'POST /users/:user_id/relationships' do
    context 'ログインしているとき、ユーザーをフォローした場合' do
      let!(:user) { create(:user) }
      let!(:another_user) { create(:user, email: 'another_user@example.com') }

      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      it 'フォローの数が1増えること' do
        aggregate_failures do
          expect do
            post user_relationships_path(another_user)
          end.to change(Relationship, :count).by(1)
          expect(user.active_relationships.count).to eq(1)
          expect(another_user.passive_relationships.count).to eq(1)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(users_path)
        end
      end
    end

    context 'ログインしていないとき、ユーザーをフォローした場合' do
      let!(:user) { create(:user) }
      let!(:another_user) { create(:user, email: 'another_user@example.com') }

      it 'フォローの数が変化せず、ログインページにリダイレクトすること' do
        aggregate_failures do
          expect do
            post user_relationships_path(another_user)
          end.to change(Relationship, :count).by(0)
          expect(user.active_relationships.count).to eq(0)
          expect(another_user.passive_relationships.count).to eq(0)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to login_path
        end
      end
    end
  end

  describe 'DELETE /users/:user_id/relationships' do
    context 'ログインしているとき、ユーザーのフォローを解除した場合' do
      let!(:user) { create(:user) }
      let!(:another_user) { create(:user, email: 'another_user@example.com') }

      before do
        post login_path, params: { email: user.email, password: user.password }
        post user_relationships_path(another_user)
      end

      it 'フォローの数が1減ること' do
        aggregate_failures do
          expect do
            delete user_relationships_path(another_user)
          end.to change(Relationship, :count).by(-1)
          expect(user.active_relationships.count).to eq(0)
          expect(another_user.passive_relationships.count).to eq(0)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(users_path)
        end
      end
    end

    context 'ログインしていないとき、ユーザーのフォローを解除した場合' do
      let!(:user) { create(:user) }
      let!(:another_user) { create(:user, email: 'another_user@example.com') }

      before do
        post login_path, params: { email: user.email, password: user.password }
        post user_relationships_path(another_user)
        delete logout_path
      end

      it 'フォローの数が変化せず、ログインページにリダイレクトすること' do
        aggregate_failures do
          expect do
            delete user_relationships_path(another_user)
          end.to change(Relationship, :count).by(0)
          expect(user.active_relationships.count).to eq(1)
          expect(another_user.passive_relationships.count).to eq(1)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to login_path
        end
      end
    end
  end
end
