class Comment < ApplicationRecord
  belongs_to :post, optional: true
  mount_uploader :image, ImageUploader
  validates :body, length: { minimum: 20 }, presence: true
end
