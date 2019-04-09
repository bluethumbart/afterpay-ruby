require "spec_helper"

RSpec.describe Afterpay do
  it "has version number" do
    expect(Afterpay::VERSION).not_to be nil
  end

  describe "#configure", :vcr do
    it "setups configuration" do
      Afterpay.configure do |config|
        config.app_id = 1
        config.secret = "secretive"
      end

      config = Afterpay.config

      expect(config.app_id).to eq(1)
      expect(config.secret).to eq("secretive")
      expect(config.env).to eq("sandbox")
      expect(config.maximum_amount).to eq(1000.0)
    end
  end
end
