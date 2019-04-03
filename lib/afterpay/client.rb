require "faraday"
require "faraday_middleware"
require "base64"
require "delegate"

module Afterpay
  class Client < SimpleDelegator
    BASE_URL = "https://api-sandbox.afterpay.com/".freeze

    class UnauthorizedError < StandardError; end

    def initialize
      super(connection)
    end

    def connection
      Faraday.new(url: BASE_URL) do |conn|
        conn.use ErrorMiddleware
        conn.authorization "Basic", Afterpay.config.auth_token
        conn.response :logger

        conn.request :json
        conn.response :json, content_type: "application/json"
        conn.adapter Faraday.default_adapter
      end
    end
  end

  class ErrorMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env).on_complete do
        case env[:status]
        when 401
          raise Client::UnauthorizedError, env.dig(:body, "message")
        end
      end
    end
  end
end
