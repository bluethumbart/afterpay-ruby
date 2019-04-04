require "spec_helper"

RSpec.describe Afterpay::Config do
  subject(:config) do
    described_class.new(
      app_id: 1,
      secret: "averylongsecretyoucanneverdecode"
    )
  end

  describe "" do
    it ""
  end
end
