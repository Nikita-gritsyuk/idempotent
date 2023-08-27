require 'rails_helper'

RSpec.describe AmountsController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to be_successful
    end

    it 'renders index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
