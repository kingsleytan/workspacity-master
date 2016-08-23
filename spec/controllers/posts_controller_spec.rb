require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  before(:all) do
    @admin_user = User.create(username: "testadmin", email: "testadmin@example.com", password: "password", role: "admin")
    @unauthorized_user = User.create(username: "Dummy", email: "dummy@example.com", password: "password")
    @dummy_topic = Topic.create(title: "dummy topic", description: "dummy dummy dummy dummy dummy", user_id: @admin_user.id)
    @dummy_post = Post.create(title: "dummy post", body: "dummy dummy dummy dummy dummy", user_id: @admin_user.id, topic_id: @dummy_topic.id)
  end

  describe "show all posts" do
    it "should show all posts" do
      params = {topic_id: @dummy_topic.id}
      get :index, params: params
      expect(subject).to render_template(:index)
      expect(Post.count).to eql(1)
    end
  end

  describe "add new post" do
    it "login before add post" do
      params = {topic_id: @dummy_topic.id}
      get :new, params: params
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should render new" do
      params = {topic_id: @dummy_topic.id}
      get :new, params: params, session: { id: @admin_user.id }
      current_user = subject.send(:current_user)
      expect(subject).to render_template(:new)
      expect(current_user).to be_present
    end
  end

  describe "create post" do
    it "should create new post" do
      params = { post: { title: "test new post", body: "should create new post"}, topic_id: @dummy_topic.id }
      post :create, params: params, session: { id: @admin_user.id }
      # post = assigns[:post]  #to call instance variable -> @post in postsController
      posts = Post.all # because this is an array posts[0]
      # post = post.find_by(title: "test new post")
      expect(Post.count).to eql(2)
      expect(posts[1].title).to eql("test new post")
      expect(posts[1].body).to eql("should create new post")
      expect(flash[:success]).to eql("You've created a new post.")
    end

    it "title should more than 5 characters" do
      params = { post: { title: "a", body: "test create post title length"}, topic_id: @dummy_topic.id }
      post :create, params: params,  session: { id: @admin_user.id }
      expect(flash[:danger]).to be_present
    end

    it "body should more than 20 characters" do
      params = { post: { title: "test title body length", body: "a"}, topic_id: @dummy_topic.id }
      post :create, params: params,  session: { id: @admin_user.id }
      expect(flash[:danger]).to be_present
    end

    it "body cannot be blank" do
      params = { post: { title: "test no body", body: ""}, topic_id: @dummy_topic.id }
      post :create, params: params,  session: { id: @admin_user.id }
      expect(flash[:danger]).to be_present
    end
  end

  describe "edit post" do
    it "should render edit" do
      params = { topic_id: @dummy_post.id, id: @dummy_post.id }
      get :edit, params: params, session: { id: @admin_user.id }
      post = Post.find_by(title: "dummy post")

      expect(subject).to render_template(:edit)
      expect(post.title).to eql("dummy post")
      expect(post.body).to eql("dummy dummy dummy dummy dummy")
    end


    it "should redirect if not logged in" do
      params = { topic_id: @dummy_post.id, id: @dummy_post.id }
      get :edit, params: params
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do

      params = { topic_id: @dummy_post.id, id: @dummy_post.id }
      get :edit, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

  end

  describe "update post" do

    it "should redirect if not logged in" do
      params = { topic_id: @dummy_post.id, id: @dummy_post.id, post: { title: "new title test", body: "this is to test the update title function"} }
      patch :update, params: params
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { topic_id: @dummy_post.id, id: @dummy_post.id, post: { title: "new title test", body: "this is to test the update title function"} }
      patch :update, params: params, session: { id: @unauthorized_user.id }
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update post" do
      params = { topic_id: @dummy_post.id, id: @dummy_post.id, post: { title: "new title test", body: "this is to test the update title function"} }
      patch :update, params: params, session: { id: @admin_user.id }

      @dummy_post.reload

      expect(@dummy_post.title).to eql("new title test")
      expect(@dummy_post.body).to eql("this is to test the update title function")
    end

  end

  describe "delete post" do
    it "should redirect if not logged in" do
      params = { topic_id: @dummy_post.id, id: @dummy_post.id }
      delete :destroy, params: params
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { topic_id: @dummy_post.id, id: @dummy_post.id }
      delete :destroy, params: params, session: { id: @unauthorized_user.id }
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should delete post" do
      params = { topic_id: @dummy_post.id, id: @dummy_post.id }
      pre_delete_count = Post.count
      delete :destroy, params: params, session: { id: @admin_user.id }
      post = Post.find_by(id: @dummy_post.id)
      expect(post).to be_nil
      expect(Post.count).to eql(pre_delete_count - 1)
    end
  end

end
