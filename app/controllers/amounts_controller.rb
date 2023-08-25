class AmountsController < ApplicationController
  protect_from_forgery with: :null_session

  include IdempotentMethods

  idempotent_methods [:create]

  def index; end

  def increment
    render json: { status: 'ok',
                   total_amount: create_amount_service.call }
  end

  private

  def create_amount_service
    @create_amount_service ||= CreateAmountService.new(params[:value])
  end
end
