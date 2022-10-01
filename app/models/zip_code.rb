class ZipCode < ApplicationRecord
  attr_accessor :pulled_from_cache

  validates_presence_of :code
  validates_uniqueness_of :code

  serialize :extended_forecast, JSON

  # Temperatures stored in Celsius
  def update_from_api(zip_forecast)
    self.update!(
      low: zip_forecast.low,
      high: zip_forecast.high,
      current_temp: zip_forecast.current_temp,
      extended_forecast: zip_forecast.hourly_forecasts,
      last_cached_at: Time.now
    )
  end

  def cache_is_not_expired?
    !self.new_record? && (Time.now < self.last_cached_at + 30.minutes)
  end
end
