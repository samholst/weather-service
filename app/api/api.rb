class API < Grape::API
  mount V1::Weather
end
