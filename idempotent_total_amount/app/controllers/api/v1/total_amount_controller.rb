module Api
  module V1
    class TotalAmountController < ApplicationController
      include IdempotentMethods

      # Specify the methods that should be idempotent
      # check the IdempotentMethods module for more details
      # app/controllers/concerns/idempotent_methods.rb
      idempotent_methods [:increment]

      def increment
        @total_amount = increment_total_amount_service.call
      end

      private

      def increment_total_amount_service
        @increment_total_amount_service ||= IncrementTotalAmountService.new(params[:value])
      end
    end
  end
end
