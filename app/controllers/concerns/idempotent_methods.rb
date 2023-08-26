module IdempotentMethods
  extend ActiveSupport::Concern

  class IdempotentError < StandardError
    def initialize(message = 'idempotency_key verification failed!')
      super(message)
    end
  end

  included do
    rescue_from IdempotentError do |e|
      render json: { status: 'error', message: e.message }, status: :unprocessable_entity
    end
  end

  module ClassMethods
    def idempotent_methods(methods)
      before_action(:save_idempotent_key!, only: methods)
    end
  end

  def save_idempotent_key!
    return if params['idempotency_key'].blank?
    raise IdempotentError unless REDIS.set(idempotency_key, true, nx: true, ex: 2.seconds)
  end

  def idempotency_key
    [Rails.env, params['idempotency_key']].join(':')
  end
end
