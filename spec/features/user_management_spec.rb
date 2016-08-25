require "rails_helper"

RSpec.feature "User Management", type: :feature, js: true do
  before(:all) do
    @user = create(:user)
  end

  scenario "User registers" do

    visit root_path
    # click_button('My Account')
# login_window = window_opened_by do
#   click_button 'My Account'
# end
# find_button('My Account').click
    find("#Account").click
find("#Register").click

    fill_in 'user_field', with: 'ironman'
    fill_in 'email_field', with: 'ironman@email.com'
    fill_in 'password_field', with: 'password'
    fill_in 'password_confirmation_field', with: 'password'
    fill_in 'latitude_field', with: ''
    fill_in 'longitude_field', with: ''
    fill_in 'address_field', with: 'KL, Malaysia'

    click_button('Create Account')

    user = User.find_by(email: "ironman@email.com")

    expect(User.count).to eql(2)
    expect(user).to be_present
    expect(user.email).to eql("ironman@email.com")
    expect(user.username).to eql("ironman")
    expect(find('.flash-messages .message').text).to eql("You've created a new user.")
    expect(page).to have_current_path(root_path)
  end
end
