class AddPasswordResetTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :password_reset_token, :string
    add_column :users, :password_reset_at, :datetime
  end
end
