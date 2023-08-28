RequestParamsValidation.define do
  action :increment do
    request do
      optional :value, type: :integer,
                       value: { min: 1,
                                message: 'Value should be a natural integer.' }

      optional :idempotency_key, type: :string,
                                 length: { min: 5,
                                           message: 'Value must be at least 5 characters in length.' }
    end
  end
end
