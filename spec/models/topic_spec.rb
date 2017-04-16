require 'rails_helper'

RSpec.describe Topic, type: :model do

  context "assocation" do
    it { should have_many(:posts) }
  end

  context "title validation" do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(5)}
  end

  context "description validation" do
    it { should validate_presence_of(:description) }
    it { should validate_length_of(:description).is_at_least(20)}
  end

  context "slug callback" do
    it "should set slug" do
      topic = create(:topic)

      expect(topic.slug).to eql(topic.title.gsub(" ", "-"))
    end

    it "should update slug" do
      topic = create(:topic)

      topic.update(title: "updatedtitle")
      expect(topic.slug).to eql("updatedtitle")
    end
  end
end
