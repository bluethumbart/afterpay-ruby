# frozen_string_literal: true

module Afterpay
  class Config
    attr_accessor :app_id, :secret, :env, :raise_errors,
                  :type, :maximum_amount, :minimum_amount,
                  :description, :currency, :skip_remote_config,
                  :user_agent_header

    def initialize
      @env = "sandbox"
      @raise_errors = true
      @skip_remote_config = false
    end

    # Called only after app_id and secred is set
    def fetch_remote_config
      response = Afterpay.client.get("/v1/configuration").body[0]

      @type = response[:type]
      @minimum_amount = response.dig(:minimumAmount, :amount).to_f
      @maximum_amount = response.dig(:maximumAmount, :amount).to_f
      @description = response[:description]
    end
  end
end
