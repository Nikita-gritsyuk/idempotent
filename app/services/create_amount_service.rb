class CreateAmountService
  def initialize(amount)
    @amount = amount
  end

  def call
    return TotalAmount.get unless @amount&.nonzero?

    TotalAmount.add!(@amount)
  end
end
