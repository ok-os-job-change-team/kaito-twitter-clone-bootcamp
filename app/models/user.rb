# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true
  validates :password, presence: true

  has_many :tweets
  has_many :favorites
  # <Userモデルのインスタンス>.favorite_tweetsでいいねしたツイートを取得する
  has_many :favorite_tweets, through: :favorites, source: :tweet

  # フォローする側のUserからみたRelationshipをactive_relationshipとする
  has_many :active_relationships, class_name: 'Relationship', foreign_key: :following_id
  # 中間テーブルを介してUser(フォローされた側)を集めることを「followings」と定義
  has_many :followings, through: :active_relationships, source: :follower

  # フォローされる側のUserからみたRelationshipをpassive_relationshipとする
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: :follower_id
  # 中間テーブルを介してUser(フォローする側)を集めることを「followers」と定義
  has_many :followers, through: :passive_relationships, source: :following

  def followed_by?(user)
    # フォローしようとしているユーザー(レシーバー)がフォローされているユーザー(つまりpassive)の中から、引数に渡されたユーザー(自分)がいるかどうかを調べる
    passive_relationships.find_by(following_id: user.id).present?
  end
end
