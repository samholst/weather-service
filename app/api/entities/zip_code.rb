module Entities
  class ZipCode < Grape::Entity
    expose :code
    expose :high
    expose :low
    expose :current_temp
    expose :extended_forecast
  end
end
