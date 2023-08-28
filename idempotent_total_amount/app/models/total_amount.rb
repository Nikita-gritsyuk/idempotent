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
    raise ArgumentError, 'Value must be a integer.' unless value.is_a?(Integer)
    raise ArgumentError, 'Value must be a natural number.' unless value.positive?

    create unless exists?

    connection.execute(
      sanitize_sql_array([increment_sql_query, value])
    ).first['value']
  end

  # IMPORTANT: this qury is atomic, so it's safe to use it in a multi-threaded environment
  # query to increment the value of the total amount by the given value
  # and return the new value
  def self.increment_sql_query
    <<-SQL
      UPDATE total_amounts SET value = value + ? RETURNING value;
    SQL
  end

  private_class_method :increment_sql_query
end
