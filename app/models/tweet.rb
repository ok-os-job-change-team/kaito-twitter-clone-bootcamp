# frozen_string_literal: true

class Tweet < ApplicationRecord
  validates :user, presence: true
  validates :title, presence: true, length: { maximum: 20 }
  validates :content, presence: true, length: { maximum: 140 }

  belongs_to :user
  has_many :favorites, dependent: :destroy

  def favorited_by?(target_user_id)
    favorites.any? { |favorite| favorite.user_id == target_user_id }
  end
end
