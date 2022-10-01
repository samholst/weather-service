require "test_helper"

class Weather::ZipForecastTest < ActiveSupport::TestCase
  let(:zip) { 89123 }
  let(:lon) { 0 }
  let(:lat) { 0 }
  let(:timestamp) { Time.now }
  let(:hourly) { [{ "temp" => 10.5, "dt" => timestamp.to_i, "extra" => "yes" }, { "temp" => 15.5, "dt" => (timestamp + 5.minutes).to_i }] }
  let(:res_forcast) {
    {
      "hourly" => [{ "temp" => 10.5, "dt" => timestamp.to_i }, { "temp" => 15.5, "dt" => (timestamp + 5.minutes).to_i }],
      "current" => {
        "temp" => 55.0
      }
    }
  }

  before do
    @subject = Weather::ZipForecast.new(res_forcast, zip, lat, lon)
  end

  it "tests initialize method" do
    assert_equal(@subject.zip, zip)
    assert_equal(@subject.lat, lat)
    assert_equal(@subject.lon, lon)
    assert_nil(@subject.average)
    assert_nil(@subject.low)
    assert_nil(@subject.high)
    assert_equal(@subject.hourly_forecasts, res_forcast["hourly"])
    assert_equal(@subject.current_temp, res_forcast["current"]["temp"])
  end

  it "tests calculate method" do
    Weather::ZipForecast.any_instance.expects(:parse_temperatures).once
    Weather::ZipForecast.any_instance.expects(:calculate_average).once
    Weather::ZipForecast.any_instance.expects(:calculate_high).once
    Weather::ZipForecast.any_instance.expects(:calculate_low).once

    @subject.calculate
  end

  describe "private methods" do
    before do
      @subject.send(:parse_temperatures)
    end

    it "tests calculate_average method" do
      assert_equal(@subject.send(:calculate_average), 13.0)
    end

    it "tests calculate_low method" do
      assert_equal(@subject.send(:calculate_low), 10.5)
    end

    it "tests calculate_high method" do
      assert_equal(@subject.send(:calculate_high), 15.5)
    end

    it "tests extract_forecast_values method" do
      assert_equal(@subject.send(:extract_forecast_values, hourly), res_forcast["hourly"])
    end
  end
end
