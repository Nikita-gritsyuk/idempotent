# frozen_string_literal: true

class TotalAmount < ApplicationRecord
  # This is a singleton model, so we always have only one record (id=1) in the table

  validates :id, presence: true, uniqueness: true, numericality: { equal_to: 1 }

  def self.add!(amount_to_add)
    raise ArgumentError, 'Amount to add should be a natural number' unless natural_number?(amount_to_add)

    instance = first_or_create

    instance.with_lock do
      instance.increment(:value, amount_to_add.to_i).save
    end

    instance.value
  end

  def self.get
    pluck(:value).first || 0
  end

  def self.natural_number?(value)
    value.to_i.to_s == value.to_s && value.to_i >= 0
  end

  private_class_method :natural_number?
end
