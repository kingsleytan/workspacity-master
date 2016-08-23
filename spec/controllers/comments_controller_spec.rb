require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  before(:all) do
    @admin_user = User.create(username: "testadmin", email: "testadmin@example.com", password: "password", role: "admin")
    @unauthorized_user = User.create(username: "Dummy", email: "dummy@example.com", password: "password")
    @dummy_topic = Topic.create(title: "dummy topic", description: "dummy dummy dummy dummy dummy",
    user_id: @admin_user.id)
    @dummy_post = Post.create(title: "dummy post", body: "dummy dummy dummy dummy dummy",
    user_id: @admin_user.id, topic_id: @dummy_topic.id)
    @dummy_comment = Comment.create(body: "dummy dummy dummy dummy dummy",
    user_id: @admin_user.id, post_id: @dummy_post.id)
  end

  describe "show all comments" do
    it "should show all comments" do
      params = {topic_id: @dummy_topic.slug, post_id: @dummy_post.slug}
      get :index, params: params
      expect(subject).to render_template(:index)
      expect(Comment.count).to eql(1)
      expect(assigns[:comment]).to be_present
    end
  end

  describe "create comment" do
    it "should create new comment" do
      params = { comment: { body: "should create new comment"}, topic_id: @dummy_topic.id, post_id: @dummy_post.slug }
      post :create,xhr: true, params: params, session: { id: @admin_user.id }
      comments = Comment.all
      expect(Comment.count).to eql(2)
      expect(comments[1].body).to eql("should create new comment")
      expect(flash[:success]).to eql("Comment created")
    end

    it "body should more than 20 characters" do
      params = { comment: { body: "a"}, topic_id: @dummy_topic.id, post_id: @dummy_post.slug }
      post :create,xhr: true, params: params,  session: { id: @admin_user.id }
      expect(flash[:danger]).to be_present
    end

    it "body cannot be blank" do
      params = { comment: { body: ""}, topic_id: @dummy_topic.id, post_id: @dummy_post.slug }
      post :create,xhr: true, params: params,  session: { id: @admin_user.id }
      expect(flash[:danger]).to be_present
    end
  end

  describe "edit comment" do
    it "should edit comment" do
      params = { topic_id: @dummy_topic.id, post_id: @dummy_post.slug, id: @dummy_comment.id }
      get :edit, xhr: true, params: params, session: { id: @admin_user.id }
      expect(assigns[:comment].body).to eql(@dummy_comment.body)
    end


    it "should redirect if not logged in" do
      params = { topic_id: @dummy_topic.id, post_id: @dummy_post.slug, id: @dummy_comment.id}
      get :edit, xhr: true, params: params
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do

      params = { topic_id: @dummy_topic.id, post_id: @dummy_post.slug, id: @dummy_comment.id }
      get :edit, xhr: true, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

  end

  describe "update comment" do

    it "should redirect if not logged in" do
      params = { topic_id: @dummy_topic.id, post_id: @dummy_post.slug, id: @dummy_comment.id, comment: {body: "this is to test the update title function"} }
      patch :update, params: params
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { topic_id: @dummy_topic.id, post_id: @dummy_post.slug, id: @dummy_comment.id, comment: {body: "this is to test the update title function"} }
      patch :update, params: params, session: { id: @unauthorized_user.id }
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update comment" do
      params = { topic_id: @dummy_topic.id, post_id: @dummy_post.slug, id: @dummy_comment.id, comment: {body: "this is to test the update title function"} }
      patch :update, xhr: true, params: params, session: { id: @admin_user.id }
      @dummy_comment.reload
      expect(assigns[:comment].body).to eql(@dummy_comment.body)
      expect(@dummy_comment.body).to eql("this is to test the update title function")
    end

  end

  describe "delete comment" do
    it "should redirect if not logged in" do
      params = { topic_id: @dummy_topic.id, post_id: @dummy_post.slug, id: @dummy_comment.id}
      delete :destroy, params: params
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { topic_id: @dummy_topic.id, post_id: @dummy_post.slug, id: @dummy_comment.id }
      delete :destroy, params: params, session: { id: @unauthorized_user.id }
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should delete comment" do
      params = { topic_id: @dummy_topic.id, post_id: @dummy_post.slug, id: @dummy_comment.id}
      pre_delete_count = Comment.count
      delete :destroy, xhr: true, params: params, session: { id: @admin_user.id }
      comment = Comment.find_by(id: @dummy_comment.id)
      expect(comment).to be_nil
      expect(Comment.count).to eql(pre_delete_count - 1)
    end
  end

end
