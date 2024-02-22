RSpec.describe TweetsController, type: :request do
  describe 'GET /tweets' do
    let!(:user) { create(:user) }
    let!(:tweet) { create(:tweet, user: user) }

    context 'ログインしているとき、ひとりごと一覧ページにアクセスした場合' do
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      it 'リクエストが成功し、タイトルと本文とメールアドレスが表示されること' do
        aggregate_failures do
          get tweets_path
          expect(response.status).to eq 200
          expect(response.body).to include tweet.title
          expect(response.body).to include tweet.content
          expect(response.body).to include user.email
        end
      end
    end

    context 'ログインしていないとき、ひとりごと一覧ページにアクセスした場合' do
      it 'ログインページにリダイレクトすること' do
        aggregate_failures do
          get tweets_path
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to login_path
        end
      end
    end
  end

  describe 'GET /tweets/:id' do
    let!(:user) { create(:user) }
    let!(:tweet) { create(:tweet, user: user) }

    context 'ログインしているとき、ひとりごと詳細ページにアクセスした場合' do
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      it 'リクエストが成功し、タイトルと本文とメールアドレスが表示されること' do
        aggregate_failures do
          get tweet_path(tweet.id)
          expect(response.status).to eq 200
          expect(response.body).to include tweet.title
          expect(response.body).to include tweet.content
          expect(response.body).to include user.email
        end
      end
    end

    context 'ログインしていないとき、ひとりごと詳細ページにアクセスした場合' do
      it 'ログインページにリダイレクトすること' do
        aggregate_failures do
          get tweet_path(tweet.id)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to login_path
        end
      end
    end
  end

  describe 'GET /tweets/new' do
    let!(:user) { create(:user) }

    context 'ログインしているとき、ひとりごと投稿ページにアクセスした場合' do
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      it 'リクエストが成功し、ひとりごと投稿ページが表示されること' do
        aggregate_failures do
          get new_tweet_path
          expect(response.status).to eq 200
          expect(response.body).to include 'ひとりごと投稿'
        end
      end
    end

    context 'ログインしていないとき、ひとりごと投稿ページにアクセスした場合' do
      it 'ログインページにリダイレクトすること' do
        aggregate_failures do
          get new_tweet_path
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to login_path
        end
      end
    end
  end

  describe 'POST /tweets' do
    let!(:user) { create(:user) }

    context 'ログインしているとき、ひとりごとを投稿した場合' do
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      it '投稿に成功し、ひとりごと一覧ページにリダイレクトすること' do
        aggregate_failures do
          expect do
            post tweets_path params: { tweet: { title: 'sample_title', content: 'sample_content', user_id: user.id } }
          end.to change(Tweet, :count).by(1)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to tweets_path
        end
      end
    end

    context 'ログインしていないとき、ひとりごとを投稿した場合' do
      it 'ログインページにリダイレクトすること' do
        aggregate_failures do
          expect do
            post tweets_path params: { tweet: { title: 'sample_title', content: 'sample_content', user_id: user.id } }
          end.to change(Tweet, :count).by(0)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to login_path
        end
      end
    end
  end

  describe 'GET tweets/:id/edit' do
    let!(:tweet) { create(:tweet, user: user) }

    context 'ログインユーザーと同じユーザーのひとりごと編集ページへアクセスする場合' do
      let!(:user) { create(:user) }

      before do
        post login_path, params: { email: user.email, password: 'sample_password' }
      end

      it 'ひとりごと編集ページに遷移すること' do
        aggregate_failures do
          get edit_tweet_path(tweet.id)
          expect(response.status).to eq 200
          expect(response.body).to include 'ひとりごと編集'
        end
      end
    end

    context 'ログインユーザーと異なるユーザーのひとりごと編集ページへアクセスする場合' do
      let!(:user) { create(:user) }
      let!(:another_user) { create(:user, email: 'hoge@example.com') }

      before do
        post login_path, params: { email: another_user.email, password: 'sample_password' }
      end

      it 'ユーザーリストページにリダイレクトすること' do
        aggregate_failures do
          get edit_tweet_path(tweet.id)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to users_path
        end
      end
    end
  end

  describe 'PUT /tweets/:id' do
    let!(:tweet) { create(:tweet, user: user) }

    context 'ログインユーザーと同じユーザーのひとりごとを修正し、なおかつタイトルと本文が正常な場合' do
      let!(:user) { create(:user) }

      before do
        post login_path, params: { email: user.email, password: 'sample_password' }
      end

      it '修正に成功すること' do
        aggregate_failures do
          put tweet_path(tweet.id), params: { tweet: { title: 'new_title', content: 'new_content', user_id: user.id } }
          expect(tweet.reload.title).to eq 'new_title'
          expect(tweet.reload.content).to eq 'new_content'
        end
      end
    end

    context 'ログインユーザーと同じユーザーのひとりごとを修正し、なおかつタイトルと本文が異常で、バリデーションエラーとなる場合' do
      let!(:user) { create(:user) }

      before do
        post login_path, params: { email: user.email, password: 'sample_password' }
      end

      it '修正に失敗すること' do
        aggregate_failures do
          put tweet_path(tweet.id), params: { tweet: { title: '', content: '', user_id: user.id } }
          expect(tweet.reload.title).to eq tweet.title
          expect(tweet.reload.content).to eq tweet.content
          expect(response.body).to include '修正に失敗しました'
        end
      end
    end

    context 'ログインユーザーと異なるユーザーのひとりごとを修正する場合' do
      let!(:user) { create(:user) }
      let!(:another_user) { create(:user, email: 'hoge@example.com') }

      before do
        post login_path, params: { email: another_user.email, password: 'sample_password' }
      end

      it 'ユーザーリストページにリダイレクトすること' do
        aggregate_failures do
          put tweet_path(tweet.id), params: { tweet: { title: 'new_title', content: 'new_content', user_id: user.id } }
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to users_path
        end
      end
    end
  end

  describe 'DELETE /tweets' do
    let!(:tweet) { create(:tweet, user: user) }

    context 'ログインユーザーと同じユーザーのひとりごとを削除する場合' do
      let!(:user) { create(:user) }

      before do
        post login_path, params: { email: user.email, password: 'sample_password' }
      end

      it '削除に成功すること' do
        expect do
          delete tweet_path(tweet.id)
        end.to change(Tweet, :count).by(-1)
      end
    end

    context 'ログインユーザーと異なるユーザーのひとりごとを削除する場合' do
      let!(:user) { create(:user) }
      let!(:another_user) { create(:user, email: 'hoge@example.com') }

      before do
        post login_path, params: { email: another_user.email, password: 'sample_password' }
      end

      it 'ひとりごと一覧ページにリダイレクトすること' do
        aggregate_failures do
          delete tweet_path(tweet.id)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to users_path
        end
      end
    end
  end
end
