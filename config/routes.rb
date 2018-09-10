Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Users
      get '/users/:id', to: 'users#show' 
      post '/users', to: 'users#create'

      # Ideas
      get '/ideas', to: 'ideas#index'

      # Contributions
      post '/ideas/:id/contributions', to: 'contributions#create'
    end
  end
end
