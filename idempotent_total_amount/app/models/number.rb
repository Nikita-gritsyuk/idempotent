class Number < ApplicationRecord
  validates :value, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :cumulative_sum, presence: true, numericality: { greater_than: 0, only_integer: true }

  # Returns the cumulative sum of all Number.
  #
  # @return [Integer] The cumulative sum of all Number.
  def self.cumulative_sum
    order(cumulative_sum: :desc).pick(:cumulative_sum) || 0
  end
end
