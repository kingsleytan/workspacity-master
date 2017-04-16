require "rails_helper"

RSpec.feature "User adds new comment and deletes it", type: :feature, js: true do

  before(:all) do
    @comment = create(:comment)
  end

  scenario "User adds, edits, upvotes, downvotes, and delete comment" do
    visit ("http://localhost:3000")
    find("#Account").click
    find("#Login").click
    fill_in 'user_field', with: 'abc'
    fill_in 'email_field', with: 'abc@gmail.com'
    fill_in 'password_field', with: 'abc'
    click_button('Login')
    click_button("close")

    visit("http://localhost:3000/topics/11/posts/testing-new-post-func-1-54e2fc30-e981-4351-8a79-c762a3970835/comments")
    # add comment
    fill_in 'comment_body_field', with: @comment.body
    click_button('Create Comment')
    comment = Comment.find_by(body: "dummy dummy dummy dummy dummy")
    expect(comment.body).to eql("dummy dummy dummy dummy dummy")
    expect(find('#flash-messages-container .message').text).to eql("Comment created")
    click_button("close")

    # edit comment
    # find(".this[data-id='something'] .something-else")
    find("#comment#{194 + comment.id} #edit-comment").click
    fill_in 'comment_body_field', with: "edit comment rspec test"
    click_button(".edit #comment-update-button")
    expect(comment.body).to eql("edit comment rspec test")
    expect(find('#flash-messages-container .message').text).to eql("You've updated your comment.")
  end
end
