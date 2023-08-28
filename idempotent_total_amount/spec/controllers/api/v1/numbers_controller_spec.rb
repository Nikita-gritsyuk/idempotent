require 'rails_helper'

RSpec.describe Api::V1::NumbersController, type: :controller do
  render_views

  let(:amount) { 10 }

  context 'when amount is valid and no idmpotency key is provided' do
    it 'returns amount' do
      post :create, params: { number: { value: amount } }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ "number" => { 'value' => amount }, "status" => 'ok' })
    end

    it 'invrements existing cumulative_sum' do
      expect { post :create, params: { number: { value: amount } } }.to change { Number.cumulative_sum }.by(amount)
      expect { post :create, params: { number: { value: amount } } }.to change { Number.cumulative_sum }.by(amount)
      expect { post :create, params: { number: { value: amount } } }.to change { Number.cumulative_sum }.by(amount)
    end

    it 'creates number record' do
      expect { post :create, params: { number: { value: amount } } }.to change { Number.count }.by(1)
    end

    it 'returns cumulative sum' do
      post :create, params: { number: { value: amount } }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ "number" => { 'value' => amount }, "status" => 'ok' })
    end
  end

  context 'when amount is valid and idmpotency key is provided' do
    let(:idempotency_key) { SecureRandom.uuid }

    it 'returns amount' do
      post :create, params: { number: { value: amount }, idempotency_key: }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ "number" => { 'value' => amount }, "status" => 'ok' })
    end

    it 'invrements existing cumulative_sum only when a new idempotency key is provided' do
      expect { post :create, params: { number: { value: amount }, idempotency_key: } }.to change {
                                                                                            Number.cumulative_sum
                                                                                          }.by(amount)
      expect { post :create, params: { number: { value: amount }, idempotency_key: } }.to change {
                                                                                            Number.cumulative_sum
                                                                                          }.by(0)
      expect { post :create, params: { number: { value: amount }, idempotency_key: } }.to change {
                                                                                            Number.cumulative_sum
                                                                                          }.by(0)
    end

    it 'creates number record' do
      expect { post :create, params: { number: { value: amount }, idempotency_key: } }.to change {
                                                                                            Number.count
                                                                                          }.by(1)
    end

    it 'returns cumulative sum' do
      post :create, params: { number: { value: amount }, idempotency_key: }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ "number" => { 'value' => amount }, "status" => 'ok' })
    end
  end

  context 'when amount is not a number' do
    let(:amount) { 'not a number' }
    let(:error_message) { "The value for the parameter 'value' is invalid. Value should be a valid integer" }

    it 'returns error' do
      post :create, params: { number: { value: amount } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({
                                                "error" => {
                                                  "message" => error_message
                                                },
                                                "status" => "error"
                                              })
    end

    it 'does not create number record' do
      expect { post :create, params: { number: { value: amount } } }.to change { Number.count }.by(0)
    end

    it 'does not increment cumulative_sum' do
      expect { post :create, params: { number: { value: amount } } }.to change { Number.cumulative_sum }.by(0)
    end
  end

  context 'when amount is float' do
    let(:amount) { 10.5 }
    let(:error_message) { "The value for the parameter 'value' is invalid. Value should be a valid integer" }

    it 'returns error' do
      post :create, params: { number: { value: amount } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({
                                                "error" => {
                                                  "message" => error_message
                                                },
                                                "status" => "error"
                                              })
    end

    it 'does not create number record' do
      expect { post :create, params: { number: { value: amount } } }.to change { Number.count }.by(0)
    end

    it 'does not increment cumulative_sum' do
      expect { post :create, params: { number: { value: amount } } }.to change { Number.cumulative_sum }.by(0)
    end
  end

  context 'when amount is negative' do
    let(:amount) { -10 }
    let(:error_message) { "The value for the parameter 'value' is invalid. Value should be a natural integer." }

    it 'returns error' do
      post :create, params: { number: { value: amount } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({
                                                "error" => {
                                                  "message" => error_message
                                                }, "status" => "error"
                                              })
    end

    it 'does not create number record' do
      expect { post :create, params: { number: { value: amount } } }.to change { Number.count }.by(0)
    end

    it 'does not increment cumulative_sum' do
      expect { post :create, params: { number: { value: amount } } }.to change { Number.cumulative_sum }.by(0)
    end
  end

  context 'when amount is zero' do
    let(:amount) { 0 }
    let(:error_message) { "The value for the parameter 'value' is invalid. Value should be a natural integer." }

    it 'returns error' do
      post :create, params: { number: { value: amount } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({
                                                "error" => {
                                                  "message" => error_message
                                                },
                                                "status" => "error"
                                              })
    end

    it 'does not create number record' do
      expect { post :create, params: { number: { value: amount } } }.to change { Number.count }.by(0)
    end

    it 'does not increment cumulative_sum' do
      expect { post :create, params: { number: { value: amount } } }.to change { Number.cumulative_sum }.by(0)
    end
  end

  context 'when amount is nil' do
    let(:amount) { nil }
    let(:error_message) { "The value for the parameter 'value' is invalid. Value should be a valid integer" }

    it 'returns error' do
      post :create, params: { number: { value: amount } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({
                                                "error" =>
                                                {
                                                  "message" => error_message
                                                },
                                                "status" => "error"
                                              })
    end

    it 'does not create number record' do
      expect { post :create, params: { number: { value: amount } } }.to change { Number.count }.by(0)
    end

    it 'does not increment cumulative_sum' do
      expect { post :create, params: { number: { value: amount } } }.to change { Number.cumulative_sum }.by(0)
    end
  end

  context 'when amount is not present' do
    let(:amount) { nil }

    it 'returns error' do
      post :create, params: { number: {} }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ "status" => 'ok', "number" => { "value" => 0 } })
    end

    it 'does not create number record' do
      expect { post :create, params: { number: {} } }.to change { Number.count }.by(0)
    end

    it 'does not increment cumulative_sum' do
      expect { post :create, params: { number: {} } }.to change { Number.cumulative_sum }.by(0)
    end
  end
end
