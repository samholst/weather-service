require "test_helper"

class V1::WeatherTest < ActionDispatch::IntegrationTest
  let(:user) { users :one }
  let(:address) { "One Apple Park Way, Cupertino, CA 95014" }
  let(:zip) { "95014" }
  let(:base_v1_url) { "/api/v1/weather" }
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
  let(:first_dt) { Time.now.to_i }
  let(:second_dt) { (Time.now + 1.hour).to_i }
  let(:temp) { 55.0 }
  let(:res_forecast) {
    OpenStruct.new(
      :success? => true,
      body: {
        hourly: [{ temp: 10.5, dt: first_dt }, { temp: 15.5, dt: second_dt }],
        current: {
          temp: temp
        }
      }.to_json
    )
  }
  let(:res_forecast_failure) { OpenStruct.new(:success? => false, body: { error: "Something went wrong." }.to_json) }
  let(:extended_forecast_res) { [{ "temp" => 10.5, "dt" => Time.at(first_dt).utc.to_s }, { "temp" => 15.5, "dt" => Time.at(second_dt).utc.to_s }] }

  describe 'api key' do
    it "should error with no api key" do
      get base_v1_url + "/address", params: { address: address }

      assert_equal(response.status, 401)
    end 
  end

  describe 'address endpoint' do
    it "tests valid params" do
      Weather::API.expects(:get).with(Weather::API::ZIP_ENDPOINT, zip_options).returns(res_zip)
      Weather::API.expects(:get).with(Weather::API::FORECAST_ENDPOINT, forcast_options).returns(res_forecast)

      assert_difference('ZipCode.count') do
        get base_v1_url + "/address", params: { address: address }, headers: { "X-Api-Key": user.access_keys.first.token }
      end

      zip_code = ZipCode.last
      assert_equal(zip_code.code, zip.to_i)
      assert_equal(zip_code.low, 10.5)
      assert_equal(zip_code.high, 15.5)
      assert_equal(zip_code.extended_forecast, extended_forecast_res)
      assert_equal(zip_code.current_temp, temp)

      zip_code = ZipCode.last
      zip_code.pulled_from_cache = false

      assert_equal(response.body, Entities::ZipCode.represent(zip_code).to_json)
      value(response).must_be :successful?
    end

    it "tests invalid params" do
      Weather::API.expects(:get).at_most(0)

      refute_difference('ZipCode.count') do
        get base_v1_url + "/address", params: { address: "123" }, headers: { "X-Api-Key": user.access_keys.first.token }
      end

      assert_equal(response.code, "400")
    end

    it "tests cached zip with valid params" do
      ZipCode.create!(
        code: zip,
        low: 10.5,
        high: 15.5,
        extended_forecast: extended_forecast_res,
        current_temp: temp,
        last_cached_at: Time.now
      )
      Weather::API.expects(:get).at_most(0).with(Weather::API::ZIP_ENDPOINT, zip_options).returns(res_zip)
      Weather::API.expects(:get).at_most(0).with(Weather::API::FORECAST_ENDPOINT, forcast_options).returns(res_forecast)

      refute_difference('ZipCode.count') do
        get base_v1_url + "/address", params: { address: address }, headers: { "X-Api-Key": user.access_keys.first.token }
      end

      zip_code = ZipCode.last
      zip_code.pulled_from_cache = true

      assert_equal(response.body, Entities::ZipCode.represent(zip_code).to_json)
      value(response).must_be :successful?
    end

    it "tests failed API first weather request" do
      Weather::API.expects(:get).with(Weather::API::ZIP_ENDPOINT, zip_options).returns(res_zip_failure)

      refute_difference('ZipCode.count') do
        get base_v1_url + "/address", params: { address: address }, headers: { "X-Api-Key": user.access_keys.first.token }
      end

      assert_equal(response.code, "400")
    end

    it "tests failed API second weather request" do
      Weather::API.expects(:get).with(Weather::API::ZIP_ENDPOINT, zip_options).returns(res_zip)
      Weather::API.expects(:get).with(Weather::API::FORECAST_ENDPOINT, forcast_options).returns(res_forecast_failure)

      refute_difference('ZipCode.count') do
        get base_v1_url + "/address", params: { address: address }, headers: { "X-Api-Key": user.access_keys.first.token }
      end

      assert_equal(response.code, "400")
    end
  end
end
