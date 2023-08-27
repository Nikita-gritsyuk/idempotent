# Singleton model representing the total amount
class TotalAmount < ApplicationRecord
  # This is a singleton model, so we always have only one record (id=1) in the table

  validates :id, presence: true, uniqueness: true, numericality: { equal_to: 1 }

  # Returns the current value of the total amount
  def self.current_value
    pick(:value) || 0
  end

  # Adds the given value to the total amount and returns the new value
  def self.increment!(value)
    raise ArgumentError, 'Value must be a natural number' unless natural_number?(value)

    create unless exists?

    connection.execute(
      sanitize_sql_array([increment_sql_query, value])
    ).first['value']
  end

  # Private methods going here
  # Returns true if the given value is a natural number, false otherwise
  def self.natural_number?(value)
    value.to_i.to_s == value.to_s && value.to_i.positive?
  end

  # IMPORTANT: this qury is atomic, so it's safe to use it in a multi-threaded environment
  # query to increment the value of the total amount by the given value
  # and return the new value
  def self.increment_sql_query
    <<-SQL
      UPDATE total_amounts SET value = value + ? RETURNING value;
    SQL
  end

  private_class_method :natural_number?, :increment_sql_query
end
