class Post < ApplicationRecord

  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :comments
  belongs_to :topic
  mount_uploader :image, ImageUploader
  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  belongs_to :user

  def self.search(search)
    where("name LIKE ?", "%#{search}%")
    where("content LIKE ?", "%#{search}%")
  end
end
