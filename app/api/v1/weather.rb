module V1
  class Weather < Grape::API
    version 'v1'
    format :json
    prefix :api

    rescue_from :all do |e|
      error!({ error: e&.message }, 500, { 'Content-Type' => 'application/json' })
    end

    # Set to local host since app is not live
    SITE_NAME = "http://localhost:3000/"

    helpers do
      def current_user
        @current_user ||= AccessKey.find_by_token(request.headers["X-Api-Key"])&.user
      end

      def same_origin_request
        request.env["HTTP_REFERER"] == SITE_NAME
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless current_user || same_origin_request
      end
    end

    resource :weather do
      desc 'Retrieves the weather based on an address.'
      params do
        requires :address, type: String, except_values: { value: [""] }, desc: 'The address to retrieve the weather for.'
      end
      get :address do
        authenticate!

        address = ::Weather::AddressParser.new(params[:address]) 
        address.parse_zip

        code = ZipCode.find_or_initialize_by(code: address.zip)
        code.pulled_from_cache = false

        if code.cache_is_not_expired?
          code.pulled_from_cache = true
          return present(code, with: Entities::ZipCode)
        end

        weather_api = ::Weather::API.new(zip: address.zip)
        zip_forecast = weather_api.get_result

        if zip_forecast
          zip_forecast.calculate
          code.update_from_api(zip_forecast)

          present(code, with: Entities::ZipCode)
        else
          error!("Please try again. Could not find zip code within address.", 400)
        end
      end
    end
  end
end
