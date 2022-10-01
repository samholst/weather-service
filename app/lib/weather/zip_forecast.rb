module Weather
  class ZipForecast
    attr_reader :high, :low, :average, :zip, :hourly_forecasts, :current_temp

    def initialize(result, zip)
      @zip = zip
      @average = nil
      @low = nil
      @high = nil
      @temperatures = []
      @hourly_forecasts = result["hourly"]
      @current_temp = result["current"]["temp"]
    end

    def calculate
      parse_temperatures
      calculate_average
      calculate_high
      calculate_low
    end

    private

    def parse_temperatures
      hourly_forecasts.each do |hour_forecast|
        hour_forecast["dt"] = Time.at(hour_forecast["dt"]).utc.to_s
        @temperatures.push(hour_forecast["temp"])
      end
    end

    def calculate_average
      @average ||= @temperatures.sum / hourly_forecasts.length
    end

    def calculate_low
      @low ||= @temperatures.min
    end

    def calculate_high
      @high ||= @temperatures.max
    end
  end
end
