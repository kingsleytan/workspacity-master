require 'rails_helper'

RSpec.describe Vote, type: :model do
  context "assocation" do
    it { should belong_to(:comment) }
    it { should belong_to(:user) }
  end
end
