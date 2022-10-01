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

  describe 'with no cached values' do
    before do
      @subject = Weather::API.new(zip)
    end

    it "tests initialize method" do
      assert_equal(@subject.zip, zip)
      assert_nil(@subject.lat, lat)
      assert_nil(@subject.lon, lon)
    end

    it "tests get_result method with success" do
      Weather::API.expects(:get).with(Weather::API::ZIP_ENDPOINT, zip_options).returns(res_zip)
      Weather::API.expects(:get).with(Weather::API::FORECAST_ENDPOINT, forcast_options).returns(res_forcast)

      assert_equal(@subject.get_result.class, Weather::ZipForecast)
    end

    it "tests get_result method with failed first API request" do
      Weather::API.expects(:get).with(Weather::API::ZIP_ENDPOINT, zip_options).returns(res_zip_failure)

      assert_nil(@subject.get_result)
    end

    it "tests get_result method with failed second API request" do
      Weather::API.expects(:get).with(Weather::API::ZIP_ENDPOINT, zip_options).returns(res_zip)
      Weather::API.expects(:get).with(Weather::API::FORECAST_ENDPOINT, forcast_options).returns(res_forcast_failure)

      assert_nil(@subject.get_result)
    end

    describe "private methods" do
      it "tests build_zip_endpoint_params method" do
        assert_equal(@subject.send(:build_zip_endpoint_params), zip_options)
      end

      it "tests build_forecast_endpoint_params method" do
        forcast_options[:query][:lat] = nil
        forcast_options[:query][:lon] = nil
        assert_equal(@subject.send(:build_forecast_endpoint_params), forcast_options)
      end
    end
  end

  describe 'with cached values' do
    before do
      @subject = Weather::API.new(zip, lat, lon)
    end

    it "tests initialize method with lat/lon" do
      assert_equal(@subject.zip, zip)
      assert_equal(@subject.lat, lat)
      assert_equal(@subject.lon, lon)
    end

    it "tests get_result method with cached lat/lon" do
      Weather::API.expects(:get).with(Weather::API::ZIP_ENDPOINT, zip_options).at_most(0)
      Weather::API.expects(:get).with(Weather::API::FORECAST_ENDPOINT, forcast_options).returns(res_forcast).at_most(1)

      assert_equal(@subject.get_result.class, Weather::ZipForecast)
    end

    describe "private methods" do
      it "tests build_forecast_endpoint_params method" do
        assert_equal(@subject.send(:build_forecast_endpoint_params), forcast_options)
      end
    end
  end
end
