class CreateAmountService
  def initialize(amount)
    @amount = amount.to_i
  end

  def call
    return TotalAmount.get unless @amount&.nonzero?

    TotalAmount.add!(@amount)
  end
end
