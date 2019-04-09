# frozen_string_literal: true

module Afterpay
  # Error class with accessor to methods
  # Afterpay error returns the same format containing
  # `errorId`, `errorCode`, `message`
  class Error
    attr_accessor :code, :id, :message

    def initialize(response)
      @id = response[:errorId]
      @code = response[:errorCode]
      @message = response[:message]
    end
  end
end
