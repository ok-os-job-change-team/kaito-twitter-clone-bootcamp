# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true, length: { maximum: 15 }
  validates :email, presence: true
  validates :password, presence: true

  has_many :tweets, dependent: :destroy
  has_many :favorites, dependent: :destroy
  # <Userモデルのインスタンス>.favorite_tweetsでいいねしたツイートを取得する
  has_many :favorite_tweets, through: :favorites, source: :tweet, dependent: :destroy

  # フォローする側のUserからみたRelationshipをactive_relationshipとする
  has_many :active_relationships, class_name: 'Relationship', foreign_key: :following_id, dependent: :destroy
  # 中間テーブルを介してUser(フォローされた側)を集めることを「followings」と定義
  has_many :followings, through: :active_relationships, source: :follower, dependent: :destroy

  # フォローされる側のUserからみたRelationshipをpassive_relationshipとする
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: :follower_id, dependent: :destroy
  # 中間テーブルを介してUser(フォローする側)を集めることを「followers」と定義
  has_many :followers, through: :passive_relationships, source: :following, dependent: :destroy

  def followed_by?(target_user_id)
    # フォローしようとしているユーザー(レシーバー)がフォローされているユーザー(つまりpassive)の中から、引数に渡されたユーザー(自分)がいるかどうかを調べる
    passive_relationships.find_by(following_id: target_user_id).present?
  end
end
