module Entities
  class ZipCode < Grape::Entity
    expose :code
    expose :high
    expose :low
    expose :current_temp
    expose :extended_forecast
    expose :pulled_from_cache
  end
end
