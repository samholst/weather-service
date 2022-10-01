require 'test_helper'

class UserTest < ActiveSupport::TestCase
  let(:user) { User.new }

  it "test invalid content" do
    refute(user.valid?) 
  end

  it "requires a number and message" do
    user.name = "user"

    assert(user.valid?) 
  end
end
