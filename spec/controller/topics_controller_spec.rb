require 'rails_helper'

RSpec.describe TopicsController, type: :controller do

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

# What happens if the user is not logged in
# What happens if the user is not authorized
# What happens if the user has all the right credentials
end
