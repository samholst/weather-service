# frozen_string_literal: true

module Weather
  class API 
    include HTTParty
    base_uri 'https://api.openweathermap.org'
    ZIP_ENDPOINT = '/data/2.5/weather'
    FORECAST_ENDPOINT = '/data/3.0/onecall'
    APP_ID = Rails.application.credentials.weather_api_key

    attr_reader :zip

    def initialize(zip:)
      @zip = zip
    end

    # Makes two API requests:
    # 1st. To get the lat/lon based on the ZIP provided
    # 2nd. Retrieve forecast data from the provided lat/lon coordinates
    def get_result
      return nil if zip.blank?

      zip_response = get(ZIP_ENDPOINT, build_zip_endpoint_params)

      return nil unless zip_response && zip_response["coord"]

      forecast_response = get(
        FORECAST_ENDPOINT,
        build_forecast_endpoint_params(
          zip_response["coord"]["lat"],
          zip_response["coord"]["lon"]
        )
      )

      create_zip_forecast(forecast_response)
    end

    private

    def create_zip_forecast(forecast_response)
      return nil unless forecast_response

      ZipForecast.new(forecast_response, zip)
    end

    def get(url, options)
      response = self.class.get(url, options)

      return nil unless response.success?

      JSON.parse(response.body)
    end

    def build_zip_endpoint_params
      {
        query: {
          zip: zip,
          appid: APP_ID
        }
      }
    end

    def build_forecast_endpoint_params(lat, lon)
      {
        query: {
          lat: lat,
          lon: lon,
          appid: APP_ID,
          units: 'metric'
        }
      }
    end
  end
end
