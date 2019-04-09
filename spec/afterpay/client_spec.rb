require "spec_helper"

RSpec.describe Afterpay::Client do
  describe ".server_url" do
    before do
      Afterpay.config = Afterpay::Config.new
    end

    it "returns url based on env" do
      Afterpay.config.env = "sandbox"
      expect(Afterpay::Client.server_url).to match(/sandbox.afterpay/)
    end

    it "return live URL" do
      Afterpay.config.env = "live"
      expect(Afterpay::Client.server_url).to match(/api.afterpay/)
    end

    # Resets env to sandbox once this test is done
    after(:all) do
      Afterpay.config.env = "sandbox"
    end
  end
end
