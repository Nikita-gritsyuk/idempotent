module Api
  module V1
    class NumbersController < ApplicationController
      include IdempotentMethods

      # Specify the methods that should be idempotent
      # check the IdempotentMethods module for more details
      # app/controllers/concerns/idempotent_methods.rb
      idempotent_methods [:create]

      def create
        @value = create_number_service.call
      end

      private

      def create_number_service
        @create_number_service ||= CreateNumberService.new(params.dig('number', 'value'))
      end
    end
  end
end
