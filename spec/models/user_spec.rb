RSpec.describe User do
  describe 'バリデーションのテスト' do
    context 'nameが15字以内の場合' do
      let(:user) { build(:user, name: 'hoge_hoge_hoge_') }

      it 'valid?がtrueになり、errorsに何も格納されないこと' do
        aggregate_failures do
          expect(user.valid?).to eq true
          expect(user.errors.full_messages).to eq []
        end
      end
    end

    context 'nameが15字より長い場合' do
      let(:user) { build(:user, name: 'hoge_hoge_hoge_h') }

      it 'valid?がfalseになり、errorsに「アカウント名は15字以内で入力してください」と格納される' do
        aggregate_failures do
          result = user.valid?
          expect(result).to eq false
          expect(user.errors.full_messages).to eq ['アカウント名は15字以内で入力してください']
        end
      end
    end

    context 'nameが空文字の場合' do
      let(:user) { build(:user, name: '') }

      it 'valid?がfalseになり、errorsに「アカウント名を入力してください」と格納される' do
        aggregate_failures do
          result = user.valid?
          expect(result).to eq false
          expect(user.errors.full_messages).to eq ['アカウント名を入力してください']
        end
      end
    end

    context 'nameがnilの場合' do
      let(:user) { build(:user, name: nil) }

      it 'valid?がfalseになり、errorsに「アカウント名を入力してください」と格納される' do
        aggregate_failures do
          result = user.valid?
          expect(result).to eq false
          expect(user.errors.full_messages).to eq ['アカウント名を入力してください']
        end
      end
    end

    context 'emailが存在する場合' do
      let(:user) { build(:user, email: 'hoge@example.com') }

      it 'valid?がtrueになる' do
        expect(user.valid?).to eq true
      end
    end

    context 'emailが空文字の場合' do
      let(:user) { build(:user, email: '') }

      it 'valid?がfalseになり、errorsに「メールアドレスを入力してください」と格納される' do
        aggregate_failures do
          result = user.valid?
          expect(result).to eq false
          expect(user.errors.full_messages).to eq ['メールアドレスを入力してください']
        end
      end
    end

    context 'emailがnilの場合' do
      let(:user) { build(:user, email: nil) }

      it 'valid?がfalseになり、errorsに「メールアドレスを入力してください」と格納される' do
        aggregate_failures do
          result = user.valid?
          expect(result).to eq false
          expect(user.errors.full_messages).to eq ['メールアドレスを入力してください']
        end
      end
    end

    context 'passwordが存在する場合' do
      let(:user) { build(:user, password: 'hogehoge') }

      it 'valid?がtrueになる' do
        expect(user.valid?).to eq true
      end
    end

    context 'passwordが空文字の場合' do
      let(:user) { build(:user, password: '') }

      it 'valid?がfalseになり、errorsに「パスワードを入力してください」と格納される' do
        aggregate_failures do
          result = user.valid?
          expect(result).to eq false
          expect(user.errors.full_messages).to eq ['パスワードを入力してください']
        end
      end
    end

    context 'passwordがnilの場合' do
      let(:user) { build(:user, password: nil) }

      it 'valid?がfalseになり、errorsに「パスワードを入力してください」と格納される' do
        aggregate_failures do
          result = user.valid?
          expect(result).to eq false
          expect(user.errors.full_messages).to eq ['パスワードを入力してください']
        end
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Tweetモデルとの関係' do
      it '1:Nとなっている' do
        association = described_class.reflect_on_association(:tweets)
        expect(association.macro).to eq(:has_many)
      end
    end
  end
end
