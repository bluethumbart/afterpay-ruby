require "spec_helper"
require "webmock/rspec"

CONFIGURATION = [{
  "type" => "PAY_BY_INSTALLMENT",
  "maximumAmount" => {
    "amount" => "1000"
  }
}]

RSpec.describe Afterpay do
  describe "#configure" do
    let(:uri) { "#{SANDBOX_URL}/v1/configuration" }

    it "setups configuration" do
      stub_request(:get, uri).to_return(body: CONFIGURATION)

      Afterpay.configure do |config|
        config.app_id = 1
        config.secret = "secretive"
        config.env    = 'sandbox'
      end

      config = Afterpay.config

      expect(config.app_id).to eq(1)
      expect(config.secret).to eq("secretive")
      expect(config.env).to eq('sandbox')
      expect(config.maximum_amount).to eq(1000.0)
    end
  end
end
