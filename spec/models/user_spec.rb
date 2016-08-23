require 'rails_helper'

RSpec.describe User, type: :model do

  context "assocation" do
    it { should have_many(:posts) }
    it { should have_many(:comments) }
    it { should have_many(:votes) }
    it { should have_many(:topics) }
  end
  # context "email validation" do
  #   it { should validate_presence_of(:email) }
  #   it { should validate_uniqueness_of(:email) }
  # end
  #
  # context "username validation" do
  #   it { should validate_presence_of(:username) }
  #   it { should validate_uniqueness_of(:username) }
  # end

  context "slug callback" do
    it "should set slug" do
      user = create(:user, :sequenced_username)
      expect(user.slug).to eql(user.username.gsub(" ", "-"))
    end

    it "should update slug" do
      user = create(:user)

      user.update(username: "updatedname")

      expect(user.slug).to eql("updatedname")
    end
  end

  context "user roles" do
    it "should be admin" do
      user = create(:user, :admin)
      expect(user.role).to eql("admin")
    end
  end

  context "user geocode" do
    it "should have longtitude and latitude" do
      user = create(:user)
      expect(user.address).to eql("KL, Malaysia")
      expect(user.longitude).to eql(101.686855)
      expect(user.latitude).to eql(3.139003)
    end
  end

end
