require "test_helper"

describe ZipCode do
  let(:zip_code) { ZipCode.new }

  it "tests invalid class" do
    refute(zip_code.valid?)
  end

  it "tests valid class" do
    zip_code.code = 89123

    assert(zip_code.valid?)
  end
end
