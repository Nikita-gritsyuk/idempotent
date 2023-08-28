require 'rails_helper'

RSpec.describe Number, type: :model do
  describe 'validations' do
    it 'validates presence of value' do
      expect do
        described_class.create!(value: nil, cumulative_sum: 10)
      end.to raise_error(ActiveRecord::RecordInvalid,
                         "Validation failed: Value can't be blank, Value is not a number")
    end

    it 'validates presence of cumulative_sum' do
      expect do
        described_class.create!(value: 10, cumulative_sum: nil)
      end.to raise_error(ActiveRecord::RecordInvalid,
                         "Validation failed: Cumulative sum can't be blank, Cumulative sum is not a number")
    end

    it 'validates numericality of value' do
      expect do
        described_class.create!(value: 'abc', cumulative_sum: 10)
      end.to raise_error(ActiveRecord::RecordInvalid,
                         "Validation failed: Value is not a number")
    end

    it 'validates numericality of cumulative_sum' do
      expect do
        described_class.create!(value: 10, cumulative_sum: 'abc')
      end.to raise_error(ActiveRecord::RecordInvalid,
                         "Validation failed: Cumulative sum is not a number")
    end

    it 'validates value is greater than 0' do
      expect do
        described_class.create!(value: 0, cumulative_sum: 10)
      end.to raise_error(ActiveRecord::RecordInvalid,
                         "Validation failed: Value must be greater than 0")
    end

    it 'validates cumulative_sum is greater than 0' do
      expect do
        described_class.create!(value: 10, cumulative_sum: 0)
      end.to raise_error(ActiveRecord::RecordInvalid,
                         "Validation failed: Cumulative sum must be greater than 0")
    end

    it 'validates value is an integer' do
      expect do
        described_class.create!(value: 0.1, cumulative_sum: 10)
      end.to raise_error(ActiveRecord::RecordInvalid,
                         "Validation failed: Value must be an integer")
    end

    it 'validates cumulative_sum is an integer' do
      expect do
        described_class.create!(value: 10, cumulative_sum: 0.1)
      end.to raise_error(ActiveRecord::RecordInvalid,
                         "Validation failed: Cumulative sum must be an integer")
    end
  end

  describe 'class methods' do
    describe 'cumulative_sum' do
      let(:amount) { 10 }

      it 'returns the bigest cumulative sum' do
        expect { described_class.create(value: amount, cumulative_sum: amount) }.to change {
                                                                                      described_class.cumulative_sum
                                                                                    }.by(amount)
        expect { described_class.create(value: amount, cumulative_sum: amount * 2) }.to change {
                                                                                          described_class.cumulative_sum
                                                                                        }.by(amount)
      end
    end
  end
end
