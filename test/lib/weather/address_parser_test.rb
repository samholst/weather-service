require "test_helper"

class Weather::AddressParserTest < ActiveSupport::TestCase
  let(:address) { "One Apple Park Way, Cupertino, CA 95014" }

  before do
    @subject = Weather::AddressParser.new(address)
  end

  it "tests initialize method" do
    assert_equal(@subject.address, address)
  end

  it "tests parse_zip method" do
    assert_equal(@subject.parse_zip.class, Indirizzo::Address)
  end
end
