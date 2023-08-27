class ApplicationController < ActionController::Base
  rescue_from StandardError, with: :render_error_response

  rescue_from IdempotentMethods::IdempotencyKeyAlreadyUsedError,
              with: :render_unprocessable_entity_error_response

  rescue_from ArgumentError, with: :render_unprocessable_entity_error_response

  private

  def render_error_response(exception)
    @exception = exception
    render 'errors/error', status: :internal_server_error
  end

  def render_unprocessable_entity_error_response(exception)
    @exception = exception
    render 'errors/error', status: :unprocessable_entity
  end
end
