class Topic < ApplicationRecord

  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :posts
  validates :title, length: { minimum: 5 }, presence: true
  validates :description, length: { minimum: 20 }, presence: true
  paginates_per 2

  #   def self.search(search)
  #   if search
  #     find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
  #   else
  #     find(:all)
  #   end
  # end

  before_save :update_slug

  private

  def update_slug
    if title
      self.slug = title.gsub(" ", "-")
    end
  end
end
