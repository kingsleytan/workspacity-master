require 'rails_helper'

RSpec.describe LandingController, type: :controller do

  describe "index" do
    it "should render index" do
      get :index
      expect(subject).to render_template(:index)
    end
  end
end
