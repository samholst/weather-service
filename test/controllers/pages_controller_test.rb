require "test_helper"

describe PagesController do
  it "gets index" do
    get root_path
    value(response).must_be :successful?
  end
end
