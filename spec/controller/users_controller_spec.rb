require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before(:all) do
    @admin_user = User.create(username: "testadmin", email: "testadmin@example.com", password: "password")
    @unauthorized_user = User.create(username: "Dummy", email: "dummy@example.com", password: "password")
  end

  describe "render new" do
    it "should render new" do
      get :new
      expect(subject).to render_template(:new)
      expect(assigns[:user]).to be_present
    end
  end

  describe "create user" do
    it "should create new user" do
      params = { user: { email: "user@gmail.com", username: "new test", password: "password"} }
      post :create, params: params

      user = User.find_by(email: "user@gmail.com")

      expect(User.count).to eql(3)
      expect(user.email).to eql("user@gmail.com")
      expect(user.username).to eql("new test")
      expect(flash[:success]).to eql("You've created a new user.")


    end
  end


  describe "edit user" do

    it "should redirect if not logged in" do
      params = { id: @admin_user.id }
      get :edit, params: params
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should redirect if user unauthorized" do

      params = { id: @admin_user.id }
      get :edit, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    # it "should render edit" do
    #
    #   params = { id: @admin_user.id }
    #   get :edit, params: params, session: { id: @admin_user.id }
    #
    #   current_user = subject.send(:current_user)
    #   binding.pry
    #   expect(subject).to render_template(:edit)
    #   expect(current_user).to be_present
    # end

    it "should update user" do

      params = { id: @admin_user.id, user: { email: "new@email.com", username: "newusername", password: "newpassword" } }
      patch :update, params: params, session: { id: @admin_user.id }

      @admin_user.reload
      current_user = subject.send(:current_user).reload

      expect(current_user.email).to eql("new@email.com")
      expect(current_user.username).to eql("newusername")
      expect(current_user.authenticate("newpassword")).to eql(@admin_user)
    end
  end
end
