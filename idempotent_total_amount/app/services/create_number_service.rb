# Service object responsible for creating a new Number record with a given amount
# and updating the cumulative sum of all Number.
class CreateNumberService
  # Initializes a new instance of the CreateNumberService class.
  #
  # @param amount [Float] The amount to be added to the cumulative sum.
  def initialize(amount)
    @amount = amount
  end

  # Creates a new Number record with the given amount and updates the cumulative sum of all Number.
  #
  # @return [Float] The updated cumulative sum.
  def call
    return Number.cumulative_sum if @amount.nil?

    Number.transaction do
      ActiveRecord::Base.connection.execute("LOCK TABLE numbers")
      number = Number.order(created_at: :desc).first_or_initialize(value: @amount, cumulative_sum: @amount, id: 1)
      if number.new_record? && number.save!
        number.cumulative_sum
      else
        Number.create!(value: @amount, cumulative_sum: number.cumulative_sum + @amount).cumulative_sum
      end
    end
  end
end
