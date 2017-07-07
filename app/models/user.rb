class User < ApplicationRecord

  extend FriendlyId
  friendly_id :username, use: :slugged

  has_secure_password
  has_many :topics
  has_many :posts
  has_many :comments
  enum role: [:user, :moderator, :admin]
  has_many :votes
  geocoded_by :address, :lookup => :google
  after_validation :geocode          # auto-fetch coordinates

  before_save :update_slug

  validates :email, presence: true,
                    uniqueness: true
  validates :username, presence: true,
                      uniqueness: true

  private

  def update_slug
    if username
      self.slug = username.gsub(" ", "-")
    end
  end
end
