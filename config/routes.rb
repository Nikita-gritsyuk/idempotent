Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root to: 'amounts#index'

  resources :amounts, only: %i[index]

  namespace :api do
    namespace :v1 do
      namespace :total_amount do
        put :increment
      end
    end
  end
end
