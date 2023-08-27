require 'rails_helper'

RSpec.describe Api::V1::TotalAmountController, type: :controller do
  let(:amount) { 10 }

  context 'when amount is valid and there no TotalAmount in db yet' do
    it 'returns http success' do
      post :increment, params: { value: amount }
      expect(response).to have_http_status(:success)
    end

    it 'returns json with status ok' do
      post :increment, params: { value: amount }
      expect(JSON.parse(response.body)['status']).to eq('ok')
    end

    it 'returns json with total_amount' do
      post :increment, params: { value: amount }
      expect(JSON.parse(response.body)['total_amount']).to eq(amount)
    end

    it 'creates amount' do
      expect { post :increment, params: { value: amount } }.to change { TotalAmount.count }.by(1)
    end
  end

  context 'when amount is valid and there is TotalAmount in db' do
    before do
      create(:total_amount, value: 100)
    end

    it 'returns http success' do
      post :increment, params: { value: amount }
      expect(response).to have_http_status(:success)
    end

    it 'returns json with status ok' do
      post :increment, params: { value: amount }
      expect(JSON.parse(response.body)['status']).to eq('ok')
    end

    it 'returns json with total_amount' do
      post :increment, params: { value: amount }
      expect(JSON.parse(response.body)['total_amount']).to eq(amount + 100)
    end

    it 'use existing amount' do
      expect { post :increment, params: { value: amount } }.to change { TotalAmount.count }.by(0)
    end

    it 'increments existing amount' do
      expect { post :increment, params: { value: amount } }.to change { TotalAmount.first.value }.by(amount)
    end
  end

  context 'when amount is not a natural number' do
    let(:amount) { -10 }

    it 'returns http unprocessable_entity' do
      post :increment, params: { value: amount }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns json with status error' do
      post :increment, params: { value: amount }
      expect(JSON.parse(response.body)['status']).to eq('error')
    end

    it 'returns json with error message' do
      post :increment, params: { value: amount }
      expect(JSON.parse(response.body)['message']).to eq('Value must be a natural number')
    end

    it 'does not create amount' do
      expect { post :increment, params: { value: amount } }.to change { TotalAmount.count }.by(0)
    end

    it 'does not increment existing amount' do
      create(:total_amount, value: 100)
      expect { post :increment, params: { value: amount } }.to change { TotalAmount.first.value }.by(0)
    end
  end

  context 'when idempotency_key is provided' do
    before do
      REDIS.with do |redis|
        redis.del([Rails.env, idempotency_key].join(':'))
      end
    end

    let(:idempotency_key) { '123' }

    context 'when request with the same idempotency_key was not made before' do
      it 'returns http success' do
        post :increment, params: { value: amount, idempotency_key: }

        expect(response).to have_http_status(:success)
      end
    end

    context 'when request with the same idempotency_key was made before' do
      it 'returns http success' do
        post :increment, params: { value: amount, idempotency_key: }
        expect(response).to have_http_status(:success)

        post :increment, params: { value: amount, idempotency_key: }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message for second request' do
        post :increment, params: { value: amount, idempotency_key: }
        expect(JSON.parse(response.body)['total_amount']).to eq(amount)
        post :increment, params: { value: amount, idempotency_key: }
        expect(JSON.parse(response.body)['total_amount']).to eq(nil)
        expect(JSON.parse(response.body)['status']).to eq('error')
        expect(JSON.parse(response.body)['message']).to eq('idempotency_key verification failed!')
      end

      it 'does not increments existing amount' do
        expect { post :increment, params: { value: amount, idempotency_key: } }.to change {
                                                                                     TotalAmount.current_value
                                                                                   }.by(amount)
        expect { post :increment, params: { value: amount, idempotency_key: } }.to change {
                                                                                     TotalAmount.current_value
                                                                                   }.by(0)
      end
    end
  end
end
