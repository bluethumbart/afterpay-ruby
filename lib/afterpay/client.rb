require "faraday"
require "faraday_middleware"
require "base64"
require "delegate"

module Afterpay
  class Client
    BASE_URL = "https://api-sandbox.afterpay.com/".freeze
    delegate_missing_to :@client

    class UnauthorizedError < StandardError; end

    def initialize
      @client = build_conn
    end

    def build_conn
      Faraday.new(url: BASE_URL) do |conn|
        conn.authorization "Basic", Afterpay.config.auth_token
        conn.response :logger

        conn.request :json
        conn.response :json, content_type: "application/json"
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
