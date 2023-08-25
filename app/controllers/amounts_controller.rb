class AmountsController < ApplicationController
  protect_from_forgery with: :null_session

  include IdempotentMethods

  idempotent_methods [:increment]

  def index; end

  def increment
    render json: { status: 'ok',
                   total_amount: create_amount_service.call }
  rescue ArgumentError => e
    render json: { status: 'error',
                   message: e.message },
           status: :unprocessable_entity
  end

  private

  def create_amount_service
    @create_amount_service ||= CreateAmountService.new(params[:value])
  end
end
