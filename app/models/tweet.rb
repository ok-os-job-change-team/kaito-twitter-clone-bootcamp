# frozen_string_literal: true

class Tweet < ApplicationRecord
  validates :user, presence: true
  validates :title, presence: true
  validates :content, presence: true

  belongs_to :user
end
