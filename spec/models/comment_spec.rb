require 'rails_helper'

RSpec.describe Comment, type: :model do

  context "assocation" do
    it { should belong_to(:post) }
    it { should have_many(:votes) }
  end

  context "body validation" do
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_least(20)}
  end

  context "total votes" do
    it "should show upvote" do
      comment = create(:comment)
      user = create(:user)
      vote = user.votes.create(comment_id: comment.id, value: +1)
      expect(vote.value).to eql(user.votes.pluck(:value).sum)
    end

    it "should show downvote" do
      comment = create(:comment)
      user = create(:user)
      vote = user.votes.create(comment_id: comment.id, value: -1)
      expect(vote.value).to eql(user.votes.pluck(:value).sum)
    end

    it "should show totalvote" do
      comment = create(:comment)
      user = create(:user)
      upvote = user.votes.create(comment_id: comment.id, value: +1)
      downvote = user.votes.create(comment_id: comment.id, value: -1)
      totalvote = upvote.value + downvote.value
      expect(totalvote).to eql(0)
    end
  end
end
