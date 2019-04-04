require "faraday"
require "faraday_middleware"
require "base64"
require "delegate"

module Afterpay
  # Client object acting as the connection
  # Enables the Client to call get/post/patch/delete
  class Client < SimpleDelegator
    BASE_URL = "https://api-sandbox.afterpay.com/".freeze

    class UnauthorizedError < StandardError; end

    def initialize
      super(connection)
    end

    # The connection object
    def connection
      Faraday.new(url: BASE_URL) do |conn|
        conn.use ErrorMiddleware if Afterpay.config.raise_errors
        conn.authorization "Basic", auth_token
        conn.response :logger

        conn.request :json
        conn.response :json, content_type: "application/json"
        conn.adapter Faraday.default_adapter
      end
    end

    # Auth requires format to be Base64 encoded
    # "<app_id>:<secret>"
    def auth_token
      auth_str = "#{Afterpay.config.app_id}:#{Afterpay.config.secret}"

      Base64.strict_encode64(auth_str)
    end
  end

  # Error middleware for Faraday to raise Afterpay connection errors
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
