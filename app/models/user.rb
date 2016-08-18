class User < ApplicationRecord

  extend FriendlyId
  friendly_id :username, use: :slugged

  has_secure_password
  has_many :topics
  has_many :posts
  has_many :comments
  enum role: [:user, :moderator, :admin]
  has_many :votes
end
