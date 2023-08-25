Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :amounts, only: %i[index]
  post '/amounts/increment', to: 'amounts#increment'
end
