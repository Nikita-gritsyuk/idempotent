class ApplicationController < ActionController::Base
  # check https://github.com/felipefava/request_params_validation
  # validations are stored at app/definitions
  before_action :validate_params!

  rescue_from StandardError, with: :render_error_response

  rescue_from IdempotentMethods::IdempotencyKeyAlreadyUsedError,
              with: :render_unprocessable_entity_error_response

  rescue_from RequestParamsValidation::InvalidParameterValueError,
              with: :render_unprocessable_entity_error_response

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
