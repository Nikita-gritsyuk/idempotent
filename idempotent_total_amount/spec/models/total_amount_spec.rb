require 'rails_helper'

RSpec.describe TotalAmount, type: :model do
  describe 'class methods' do
    describe '#increment!' do
      let(:amount) { 10 }

      before do
        create(:total_amount, value: 100)
      end

      it 'increments existing amount' do
        expect { TotalAmount.increment!(amount) }.to change { TotalAmount.first.value }.by(amount)
      end

      context 'when amount is not a natural number' do
        let(:amount) { -10 }

        it 'raises ArgumentError' do
          expect { TotalAmount.increment!(amount) }.to raise_error(ArgumentError)
        end
      end

      context 'when amount is not a number' do
        let(:amount) { 'abc' }

        it 'raises ArgumentError' do
          expect { TotalAmount.increment!(amount) }.to raise_error(ArgumentError)
        end
      end

      context 'when amount is nil' do
        let(:amount) { nil }

        it 'raises ArgumentError' do
          expect { TotalAmount.increment!(amount) }.to raise_error(ArgumentError)
        end
      end

      context 'when amount is empty string' do
        let(:amount) { '' }

        it 'raises ArgumentError' do
          expect { TotalAmount.increment!(amount) }.to raise_error(ArgumentError)
        end
      end
    end

    describe '#get' do
      context 'when there is TotalAmount in db' do
        before do
          create(:total_amount, value: 100)
        end

        it 'returns amount' do
          expect(TotalAmount.current_value).to eq(100)
        end
      end

      context 'when there is no TotalAmount in db' do
        it 'returns 0' do
          expect(TotalAmount.current_value).to eq(0)
        end
      end
    end
  end
end
