# This module provides methods for ensuring that requests are idempotent, meaning
# that the same request can't be processed twice.
module IdempotentMethods
  extend ActiveSupport::Concern

  # This error is raised if the idempotency key can't be verified.
  class IdempotentError < StandardError
    def initialize(message = 'idempotency_key verification failed!')
      super(message)
    end
  end

  # This block is executed when the module is included in a class.
  included do
    # If an IdempotentError is raised, return a JSON response with an error message
    # and a status of :unprocessable_entity.
    rescue_from IdempotentError do |e|
      render json: { status: 'error', message: e.message }, status: :unprocessable_entity
    end
  end

  # This module method adds a before_action to the controller for the specified methods.
  module ClassMethods
    def idempotent_methods(methods)
      before_action(:save_idempotent_key!, only: methods)
    end
  end

  # This method saves an idempotent key to Redis, which ensures that the same
  # request can't be processed twice. If the key already exists, an error is raised.
  def save_idempotent_key!
    # If the idempotency key is blank, there's nothing to save, so return early.
    return if params['idempotency_key'].blank?

    # Set the key in Redis with a time-to-live (TTL) of either the value of the
    # IDEMPOTENT_KEY_TTL environment variable (if it's set) or 1 hour.
    ttl = ENV['IDEMPOTENT_KEY_TTL']&.to_i&.minutes || 1.hour
    REDIS.with do |redis|
      raise IdempotentError unless redis.set(idempotency_key, true, nx: true, ex: ttl)
    end
  end

  # This method returns the idempotency key, which is a combination of the Rails
  # environment and the idempotency key parameter.
  def idempotency_key
    [Rails.env, params['idempotency_key']].join(':')
  end
end
