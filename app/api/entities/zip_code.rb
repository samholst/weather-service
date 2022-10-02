require "pry"

module Entities
  class ZipCode < Grape::Entity
    expose :code
    expose :high do |instance, options|
      instance.high.to_f
    end
    expose :low do |instance, options|
      instance.low.to_f
    end
    expose :current_temp do |instance, options|
      instance.current_temp.to_f
    end
    expose :extended_forecast
    expose :pulled_from_cache
  end
end

