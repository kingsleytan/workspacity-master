require "rails_helper"

#install chrome driver
#brew install chromedriver
#brew start chromedriver

RSpec.feature "User Management", type: :feature, js: true do
  before(:all) do
    @user = create(:user, :sequenced_email, :sequenced_username)
  end

  scenario "Register New User" do

    visit root_path
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

  scenario "Login New User" do
    visit root_path
    find("#Account").click
    find("#Login").click
    fill_in 'email_field', with: @user.email
    fill_in 'password_field', with: @user.password
    click_button('Login')

    user = User.find_by(email: @user.email)

    expect(find('.flash-messages .message').text).to eql("Welcome back #{user.username}")
    expect(user).to be_present
    expect(user.email).to eql('user1@email.com')
    expect(user.username).to eql("username1")
    expect(page).to have_current_path(root_path)

  end
end
