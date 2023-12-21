# frozen_string_literal: true

class Tweet < ApplicationRecord
  validates :user_id, presence: true
  validates :title, presence: true
  validates :content, presence: true

  belongs_to :user
  has_many :favorites

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
