class User < ApplicationRecord
  has_secure_password
  has_many :topics
  has_many :posts
  has_many :comments
  enum role: [:user, :moderator, :admin]
end
