module Afterpay
  class Config
    attr_accessor :app_id, :secret, :env,
                  :type, :maximum_amount, :minimum_amount, :description

    def auth_token
      Base64.strict_encode64("#{@app_id}:#{@secret}")
    end

    def fetch_remote_config
      response = Afterpay.client.get("/v1/configuration").body[0]

      @type = response["type"]
      @minimum_amount = response.dig("minimumAmount", "amount").to_f
      @maximum_amount = response.dig("maximumAmount", "amount").to_f
      @description = response["description"]
    end
  end
end
