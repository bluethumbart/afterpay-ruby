module Afterpay
  class Config
    attr_accessor :app_id, :secret, :env,
                  :type, :maximum_amount, :minimum_amount, :description, :currency

    def initialize
      @app_id = nil
      @secret = nil
      @env = 'sandbox'
    end

    # Basic auth requires this format
    # to be Base64 encoded
    # "<app_id>:<secret>"
    def auth_token
      Base64.strict_encode64("#{@app_id}:#{@secret}")
    end

    # Called only after app_id and secred is set
    def fetch_remote_config
      response = Afterpay.client.get("/v1/configuration").body[0]

      @type = response["type"]
      @minimum_amount = response.dig("minimumAmount", "amount").to_f
      @maximum_amount = response.dig("maximumAmount", "amount").to_f
      @description = response["description"]
    end
  end
end
