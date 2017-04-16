class AddSlugToVariousTables < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :slug, :string, unique: true
    add_column :topics, :slug, :string, unique: true
    add_column :posts, :slug, :string, unique: true
  end
end
