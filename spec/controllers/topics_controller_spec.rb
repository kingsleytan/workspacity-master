require 'rails_helper'

RSpec.describe TopicsController, type: :controller do

  before(:all) do
    @admin_user = create(:user, :admin)
    @unauthorized_user = create(:user, email: "dummy@example.com")
    @dummy_topic = create(:topic)
  end

  describe "show all topics" do
    it "should show all topics" do
      get :index
      expect(Topic.count).to eql(1)
    end
  end

  describe "add new topic" do
    it "login before add topic" do
      get :new
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should render new" do
      params = { id: @admin_user.id }
      get :new, params: params, session: { id: @admin_user.id }
      current_user = subject.send(:current_user)
      expect(subject).to render_template(:new)
      expect(current_user).to be_present
    end
  end

  describe "create topic" do
    it "should create new topic" do
      params = { topic: { title: "test new topic", description: "should create new topic"} }
      post :create, params: params, session: { id: @admin_user.id }
      # topic = assigns[:topic]  #to call instance variable -> @topic in TopicsController
      topics = Topic.all # because this is an array topics[0]
      # topic = Topic.find_by(title: "test new topic")
      expect(Topic.count).to eql(2)
      expect(topics[1].title).to eql("test new topic")
      expect(topics[1].description).to eql("should create new topic")
      expect(flash[:success]).to eql("You've created a new topic.")
    end

    it "unauthorized/only admin can add topic" do
      params = { topic: { title: "test new topic", description: "should create new topic"} }
      post :create, params: params,  session: { id: @unauthorized_user.id }
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "title should more than 5 characters" do
      params = { topic: { title: "a", description: "test create topic title length"} }
      post :create, params: params,  session: { id: @admin_user.id }
      expect(subject).to redirect_to(new_topic_path)
      expect(flash[:danger]).to be_present
    end

    it "description should more than 20 characters" do
      params = { topic: { title: "test title description length", description: "a"} }
      post :create, params: params,  session: { id: @admin_user.id }
      expect(subject).to redirect_to(new_topic_path)
      expect(flash[:danger]).to be_present
    end

    it "description cannot be blank" do
      params = { topic: { title: "test no description", description: ""} }
      post :create, params: params,  session: { id: @admin_user.id }
      expect(subject).to redirect_to(new_topic_path)
      expect(flash[:danger]).to be_present
    end
  end

  describe "edit topic" do
    it "should render edit" do
      params = { id: @dummy_topic.id }
      get :edit, params: params, session: { id: @admin_user.id }
      topic = Topic.find_by(title: "dummy topic")

      expect(subject).to render_template(:edit)
      expect(topic.title).to eql("dummy topic")
      expect(topic.description).to eql("dummy dummy dummy dummy dummy")
    end


    it "should redirect if not logged in" do
      params = { id: @dummy_topic.id }
      get :edit, params: params
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do

      params = { id: @dummy_topic.id }
      get :edit, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

  end

  describe "update topic" do

    it "should redirect if not logged in" do
      params = { id: @dummy_topic.id, topic: { title: "new title test", description: "this is to test the update title function"} }
      patch :update, params: params
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { id: @dummy_topic.id, topic: { title: "new title test", description: "this is to test the update title function"} }
      patch :update, params: params, session: { id: @unauthorized_user.id }
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update topic" do
      params = { id: @dummy_topic.id, topic: { title: "new title test", description: "this is to test the update title function"} }
      patch :update, params: params, session: { id: @admin_user.id }

      @dummy_topic.reload

      expect(@dummy_topic.title).to eql("new title test")
      expect(@dummy_topic.description).to eql("this is to test the update title function")
    end

  end

  describe "delete topic" do
    it "should redirect if not logged in" do
      params = { id: @dummy_topic.id }
      delete :destroy, params: params
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { id: @dummy_topic.id }
      delete :destroy, params: params, session: { id: @unauthorized_user.id }
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should delete topic" do
      params = { id: @dummy_topic.id }
      pre_delete_count = Topic.count
      delete :destroy, params: params, session: { id: @admin_user.id }
      topic = Topic.find_by(id: @dummy_topic.id)
      expect(topic).to be_nil
      expect(Topic.count).to eql(pre_delete_count - 1)
    end
  end

end
