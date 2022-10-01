require 'test_helper'

class AccessKeyTest < ActiveSupport::TestCase
  let(:access_key) { AccessKey.new }

  it "generates a token" do
    access_key.generate_token
    assert_not_nil(access_key.token)
  end
end
