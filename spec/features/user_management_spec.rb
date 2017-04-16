require "rails_helper"

#install chrome driver
#brew install chromedriver
#brew start chromedriver

RSpec.feature "User Management", type: :feature, js: true do
  before(:all) do
    @user = create(:user, email: "ironman@email.com", username: "ironman", password: "password")
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
    expect(find('.flash-messages').text).to eql("× You've created a new user.")
    expect(page).to have_current_path(root_path)
  end

  scenario "Login User" do
    visit root_path
    find("#Account").click
    find("#Login").click
    fill_in 'user_field', with: 'ironman'
    fill_in 'email_field', with: 'ironman@email.com'
    fill_in 'password_field', with: 'password'
    click_button('Login')
    user = User.find_by(email: "ironman@email.com")
    expect(find('.flash-messages').text).to eql("Welcome back #{user.username}")
    expect(user).to be_present
    expect(user.email).to eql('user1@email.com')
    expect(user.username).to eql("username1")
    expect(page).to have_current_path(root_path)
  end

  # scenario "Logout User" do
  #   visit root_path
  #   find("#Account").click
  #   find("#Login").click
  #   fill_in 'email_field', with: @user.email
  #   fill_in 'password_field', with: @user.password
  #   click_button('Login')
  #   find("#Account").click
  #   find("#Logout").click
  #   expect(find('.flash-messages .message').text).to eql("You've been logged out")
  #   expect(page).to have_current_path(root_path)
  # end

  scenario "username registration error" do
    visit root_path
    find("#Account").click
    find("#Register").click
    fill_in 'user_field', with: 'dummy'
    fill_in 'email_field', with: 'ironman@email.com'
    fill_in 'password_field', with: 'password'

    click_button('Create Account')

    expect(User.count).to eql(1)
  end

  scenario "email registration error" do
    visit root_path
    find("#Account").click
    find("#Register").click
    fill_in 'user_field', with: 'username1'
    fill_in 'email_field', with: @user.email
    fill_in 'password_field', with: @user.password

    click_button('Create Account')

    expect(User.count).to eql(1)
    expect(find('.flash-messages .message').text).to eql("Email has already been taken")
  end

  scenario "user redirected if not logged in" do
    visit edit_user_path(@user)

    expect(find('.flash-messages .message').text).to eql("You need to login first")
  end

  scenario "user updates details" do

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

    visit root_path
    find("#Account").click
    find("#Login").click
    fill_in 'user_field', with: 'ironman'
    fill_in 'email_field', with: 'ironman@email.com'
    fill_in 'password_field', with: 'password'
    click_button('Login')

    click_button("close")

    user = User.find_by(email: "ironman@email.com")

    visit root_path
    find("#Account").click
    find("#User").click
    fill_in 'user_field', with: "editusername"
    fill_in 'email_field', with: 'edit@email.com'
    click_button("Update Profile")


    expect(find('.flash-messages').text).to eql("× You've updated your details")
    user = User.find_by(email: "edit@email.com")

    expect(user).to be_present
    expect(user.username).to eql("editusername")

    visit root_path
    find("#Account").click
    find("#User").click
    fill_in 'user_field', with: "editusername"
    fill_in 'email_field', with: 'edit@email.com'
    fill_in 'password_field', with: "updatepassword"
    fill_in 'password_confirmation_field', with: "updatepassword"
    click_button("Update Profile")

    expect(page).to have_current_path(root_path)
    expect(find('.flash-messages .message').text).to eql("Welcome back #{user.username}")
  end

end
