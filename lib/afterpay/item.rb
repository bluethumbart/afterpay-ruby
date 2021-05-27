# frozen_string_literal: true

require "money"

module Afterpay
  class Item
    attr_accessor :name, :sku, :quantity, :page_url, :image_url, :price, :categories, :estimated_shipment_date

    # rubocop:disable Metrics/ParameterLists
    def initialize(name:, price:, page_url:, image_url:, categories:, estimated_shipment_date:, sku: nil, quantity: 1)
      @name = name
      @sku = sku
      @quantity = quantity
      @price = price
      @page_url = page_url
      @image_url = image_url
      @categories = categories
      @estimated_shipment_date = estimated_shipment_date
    end
    # rubocop:enable Metrics/ParameterLists

    def to_hash
      {
        name: name,
        sku: sku,
        quantity: quantity,
        price: {
          amount: price.amount.to_f,
          currency: price.currency.iso_code
        },
        page_url: page_url,
        image_url: image_url,
        categories: categories,
        estimated_shipment_date: estimated_shipment_date
      }
    end

    # Builds Item from response
    def self.from_response(response)
      return nil if response.nil?

      new(
        name: response[:name],
        sku: response[:sku],
        quantity: response[:quantity],
        price: Utils::Money.from_response(response[:price]),
        page_url: response[:pageUrl],
        image_url: response[:imageUrl],
        categories: response[:categories],
        estimated_shipment_date: response[:estimatedShipmentDate]
      )
    end
  end
end
