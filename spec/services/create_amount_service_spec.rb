require 'rails_helper'

RSpec.describe CreateAmountService do
  describe '#call' do
    let(:amount) { 10 }

    subject { described_class.new(amount).call }

    context 'when amount is valid and there no TotalAmount in db yet' do
      it 'returns amount' do
        expect(subject).to eq(amount)
      end

      it 'creates amount' do
        expect { subject }.to change { TotalAmount.count }.by(1)
      end
    end

    context 'when amount is valid and there is TotalAmount in db' do
      before do
        create(:total_amount, value: 100)
      end

      it 'returns amount' do
        expect(subject).to eq(amount + 100)
      end

      it 'use existing amount' do
        expect { subject }.to change { TotalAmount.count }.by(0)
      end

      it 'increments existing amount' do
        expect { subject }.to change { TotalAmount.first.value }.by(amount)
      end
    end

    context 'when amount is not a natural number' do
      let(:amount) { -10 }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(ArgumentError)
      end

      it 'does not create amount' do
        expect do
          subject
        rescue StandardError
          nil
        end.to change { TotalAmount.count }.by(0)
      end

      it 'does not increment existing amount' do
        expect do
          subject
        rescue StandardError
          nil
        end.to change { TotalAmount.get }.by(0)
      end
    end
  end
end