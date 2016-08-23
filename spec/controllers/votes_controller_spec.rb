require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  before(:all) do
    @user = create(:user, :admin)
    @dummy_comment = create(:comment, user_id: @user.id)
  end

  describe "comment upvote" do
    it "should upvote comment +1" do
      params = { comment_id: @dummy_comment.id }
      post :upvote, xhr: true, params: params, session: { id: @user.id }
      current_user = subject.send(:current_user)
      expect(Vote.first.value).to eql(1)
      expect(assigns[:vote].value).to eql(1)
    end

    it "should login before vote" do
      params = { comment_id: @dummy_comment.id }
      post :upvote, xhr: true, params: params
      expect(flash[:danger]).to eql("You need to login first")
      expect(assigns[:vote]).to be_nil
    end

    it "should create vote if first-time vote" do

      params = { comment_id: @dummy_comment.id }

      expect(Vote.all.count).to eql(0)

      post :upvote, xhr: true, params: params, session: { id: @user.id }

      expect(Vote.all.count).to eql(1)
      expect(Vote.first.user).to eql(@user)
      expect(Vote.first.comment).to eql(@dummy_comment)
      expect(assigns[:vote]).to_not be_nil
    end

    it "should not vote if voted before" do
      @dummy_vote = @user.votes.create(comment_id: @dummy_comment.id)
      expect(Vote.all.count).to eql(1)

      params = { comment_id: @dummy_comment.id }
      post :upvote, xhr: true, params: params, session: { id: @user.id }

      expect(Vote.all.count).to eql(1)
      expect(Vote.first.user).to eql(@user)
      expect(Vote.first.comment).to eql(@dummy_comment)
      expect(assigns[:vote]).to eql(@dummy_vote)
    end

  end

  describe "comment downvote" do
    it "should downvote comment -1" do
      params = { comment_id: @dummy_comment.id }
      post :upvote, xhr: true, params: params, session: { id: @user.id }
      current_user = subject.send(:current_user)
      expect(assigns[:vote].value).to eql(-1)
    end

    it "should login before vote" do
      params = { comment_id: @dummy_comment.id }
      post :upvote, xhr: true, params: params
      expect(flash[:danger]).to eql("You need to login first")
      expect(assigns[:vote]).to be_nil
    end

    it "should create vote if first-time vote" do

      params = { comment_id: @dummy_comment.id }

      expect(Vote.all.count).to eql(0)

      post :upvote, xhr: true, params: params, session: { id: @user.id }

      expect(Vote.all.count).to eql(1)
      expect(Vote.first.user).to eql(@user)
      expect(Vote.first.comment).to eql(@dummy_comment)
      expect(assigns[:vote]).to_not be_nil
    end

    it "should not vote if voted before" do
      @dummy_vote = @user.votes.create(comment_id: @dummy_comment.id)
      expect(Vote.all.count).to eql(1)

      params = { comment_id: @dummy_comment.id }
      post :upvote, xhr: true, params: params, session: { id: @user.id }

      expect(Vote.all.count).to eql(1)
      expect(Vote.first.user).to eql(@user)
      expect(Vote.first.comment).to eql(@dummy_comment)
      expect(assigns[:vote]).to eql(@dummy_vote)
    end

  end



end
