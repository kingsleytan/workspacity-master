require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before(:all) do
    @user = create(:user, :sequenced_email, :sequenced_username)
  end

  describe "render new login page" do
    it "should render new login page" do
      get :new
      expect(subject).to render_template(:new)

    end
  end

  describe "create session" do

    it "should log in user" do
      params = { user: { email: @user.email, password: "password" } }
      post :create, params: params
      current_user = subject.send(:current_user)
      user = User.find_by(email: "create@user.com")
      expect(session[:id]).to eql(user.id)
      expect(current_user).to be_present
      expect(flash[:success]).to eql("Welcome back #{user.username}")
    end
    it "should show login error" do
      params = { user: { email: @user.email, password: "fake_password" } }
      post :create, params: params

      current_user = subject.send(:current_user)

      expect(cookies.signed[:id]).to be_nil
      expect(current_user).to be_nil
      expect(flash[:danger]).to eql("Error logging in")
    end
  end
end
