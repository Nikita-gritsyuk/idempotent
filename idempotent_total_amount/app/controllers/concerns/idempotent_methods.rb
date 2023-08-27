# This module provides methods for ensuring that requests are idempotent, meaning
# that the same request can't be processed twice.
module IdempotentMethods
  extend ActiveSupport::Concern

  # Set the key in Redis with a time-to-live (TTL) of either the value of the
  # IDEMPOTENT_KEY_TTL environment variable (if it's set) or 1 hour.
  TTL = ENV['IDEMPOTENT_KEY_TTL']&.to_i&.minutes || 1.hour

  # This error is raised if the idempotency key can't be verified.
  class IdempotencyKeyAlreadyUsedError < StandardError
    def initialize(message = 'idempotency_key verification failed!')
      super(message)
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

    REDIS.with do |redis|
      raise IdempotencyKeyAlreadyUsedError unless redis.set(idempotency_key, true, nx: true, ex: TTL)
    end
  end

  # This method returns the idempotency key, which is a combination of the Rails
  # environment, controller name, action name, and the idempotency key provided
  def idempotency_key
    [Rails.env, controller_name, action_name, params['idempotency_key']].join(':')
  end
end
