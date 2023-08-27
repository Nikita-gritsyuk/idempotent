class IncrementTotalAmountService
  def initialize(amount)
    @amount = amount
  end

  def call
    return TotalAmount.current_value if @amount.blank?

    TotalAmount.increment!(@amount)
  end
end
