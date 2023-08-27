class IncrementAmountService
  def initialize(amount)
    @amount = amount.to_i
  end

  def call
    return TotalAmount.current_value unless @amount&.nonzero?

    TotalAmount.add!(@amount)
  end
end
