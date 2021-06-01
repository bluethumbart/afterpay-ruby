# frozen_string_literal: true

require "faraday"
require "faraday_middleware"
require "base64"
require "forwardable"
require "pry"

module Afterpay
  # Client object acting as the connection
  # Enables the Client to call get/post/patch/delete
  class Client
    extend Forwardable

    BASE_URL = "https://api.afterpay.com/"
    SANDBOX_BASE_URL = "https://api.us-sandbox.afterpay.com/v2/"

    class NotFoundError < StandardError; end

    class UnauthorizedError < StandardError; end

    def_delegators :@connection, :get, :put, :post, :delete

    # Decides which URL to use based on env
    def self.server_url
      Afterpay.env == "sandbox" ? SANDBOX_BASE_URL : BASE_URL
    end

    # Auth requires format to be Base64 encoded
    # `<app_id>:<secret>`
    def self.auth_token
      auth_str = "#{Afterpay.config.app_id}:#{Afterpay.config.secret}"
      Base64.strict_encode64(auth_str)
    end

    def initialize(connection = nil)
      @connection = connection || default_connection
    end

    # The connection object
    def default_connection
      # Use local thread to keep connection open to make use of connection reuse.
      Thread.current[:afterpay_default_connection] ||=
        Faraday.new(url: self.class.server_url) do |conn|
          conn.use ErrorMiddleware if Afterpay.config.raise_errors
          conn.authorization "Basic", self.class.auth_token
          # conn.headers["User-Agent"] = Afterpay.config.user_agent_header if Afterpay.config.user_agent_header.present?

          conn.request :json
          conn.response :json, content_type: "application/json", parser_options: { symbolize_names: true }
          conn.adapter Faraday.default_adapter
        end
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
        when 404
          raise Client::NotFoundError, env.body[:message]
        when 401
          raise Client::UnauthorizedError, env.body[:message]
        end
      end
    end
  end
end
