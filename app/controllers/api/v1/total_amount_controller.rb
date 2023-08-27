module Api
  module V1
    class TotalAmountController < ApplicationController
      include IdempotentMethods

      idempotent_methods [:increment]

      def increment
        render json: { status: 'ok', total_amount: create_amount_service.call }
      rescue ArgumentError => e
        render json: { status: 'error', message: e.message },
               status: :unprocessable_entity
      end

      private

      def create_amount_service
        @create_amount_service ||= IncrementAmountService.new(params[:value])
      end
    end
  end
end
