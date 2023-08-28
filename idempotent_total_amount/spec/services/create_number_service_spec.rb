require 'rails_helper'

RSpec.describe CreateNumberService do
  describe '#call' do
    let(:amount) { 10 }

    let(:service) { described_class.new(amount) }
    let(:random_numbers) { Array.new(1000) { rand(1..100) } }

    context 'when amount is valid' do
      it 'returns amount' do
        expect(service.call).to eq(amount)
      end

      it 'invrements existing cumulative_sum' do
        expect { service.call }.to change { Number.cumulative_sum }.by(amount)
        expect { service.call }.to change { Number.cumulative_sum }.by(amount)
        expect { service.call }.to change { Number.cumulative_sum }.by(amount)
      end

      it 'creates number record' do
        expect { service.call }.to change { Number.count }.by(1)
        expect { service.call }.to change { Number.count }.by(1)
        expect { service.call }.to change { Number.count }.by(1)
      end

      it 'returns cumulative sum' do
        random_numbers.each do |number|
          described_class.new(number).call
        end

        expect(Number.cumulative_sum).to eq(random_numbers.sum)
        expect(Number.cumulative_sum).to eq(Number.sum(:value))
      end
    end

    context 'when amount is a string' do
      let(:amount) { 'invalid' }

      it 'raises an error' do
        expect { service.call }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when amount is a negative number' do
      let(:amount) { -1 }

      it 'raises an error' do
        expect { service.call }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when amount is a float' do
      let(:amount) { 1.1 }

      it 'raises an error' do
        expect { service.call }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when amount is a zero' do
      let(:amount) { 0 }

      it 'raises an error' do
        expect { service.call }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when amount is nil' do
      let(:amount) { nil }

      it 'return the original amount, but does not create a record' do
        expect { service.call }.to change { Number.count }.by(0)
        expect { service.call }.to change { Number.cumulative_sum }.by(0)
        expect(service.call).to eq(0)
      end
    end
  end
end
