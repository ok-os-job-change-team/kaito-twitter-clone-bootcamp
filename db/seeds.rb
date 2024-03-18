#管理者ユーザー
# seeds.rb
User.create(name: '管理者ユーザー', email: 'admin@example.jp', password: 'squeamish_ossifrage', admin: true) 

# テストユーザー
User.create(name: 'かいと', email: 'kaito@example.com', password: 'hogehoge')
User.create(name: 'しょーいち',email: 'shoichi@example.com', password: 'hohogege')

# Tweetsテーブル初期値
Tweet.create(user_id: 2, title: 'あいさつ', content: 'こんにちは')
Tweet.create(user_id: 3, title: '天気', content: '今日は晴れです')

# Favoriesテーブル初期値
Favorite.create(user_id: 2, tweet_id: 3)
Favorite.create(user_id: 3, tweet_id: 2)

# Relationshipsテーブル初期値
Relationship.create(following_id: 2, follower_id: 3)
Relationship.create(following_id: 3, follower_id: 2)
