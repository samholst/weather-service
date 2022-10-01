require "test_helper"

class Weather::APITest < ActiveSupport::TestCase
  let(:user) { users :one }
  let(:zip) { 89123 }
  let(:lon) { -123.12323 }
  let(:lat) { 89.231434 }
  let(:zip_options) {
    {
      query: {
        zip: zip,
        appid: Rails.application.credentials.weather_api_key
      }
    }
  }
  let(:forcast_options) {
    {
      query: {
        lat: lat,
        lon: lon,
        appid: Rails.application.credentials.weather_api_key,
        units: 'metric'
      }
    }
  }

  let(:res_zip) {
    OpenStruct.new(
      :success? => true,
      body: {
        coord: {
          lat: lat,
          lon: lon
        }
      }.to_json
    )
  }
  let(:res_zip_failure) { OpenStruct.new(:success? => false, body: { error: "Something went wrong." }.to_json) }
  let(:res_forcast) {
    OpenStruct.new(
      :success? => true,
      body: {
        hourly: [{ temp: 10.5, dt: "2022-10-02 01:00:00 UTC" }, { temp: 15.5, dt: "2022-10-02 01:00:00 UTC" }],
        current: {
          temp: 55.0
        }
      }.to_json
    )
  }
  let(:res_forcast_failure) { OpenStruct.new(:success? => false, body: { error: "Something went wrong." }.to_json) }

  before do
    @subject = Weather::API.new(zip: zip)
  end

  it "tests initialize method" do
    assert_equal(@subject.zip, zip)
  end

  it "tests get method with success" do
    Weather::API.expects(:get).with(Weather::API::ZIP_ENDPOINT, zip_options).returns(res_zip)
    Weather::API.expects(:get).with(Weather::API::FORECAST_ENDPOINT, forcast_options).returns(res_forcast)

    assert_equal(@subject.get_result.class, Weather::ZipForecast)
  end

  it "tests get method with zip on failure" do
    Weather::API.expects(:get).with(Weather::API::ZIP_ENDPOINT, zip_options).returns(res_zip_failure)

    assert_nil(@subject.get_result)
  end

  it "tests get method with zip on failure" do
    Weather::API.expects(:get).with(Weather::API::ZIP_ENDPOINT, zip_options).returns(res_zip)
    Weather::API.expects(:get).with(Weather::API::FORECAST_ENDPOINT, forcast_options).returns(res_forcast_failure)

    assert_nil(@subject.get_result)
  end
end
