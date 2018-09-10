Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Ideas
      get '/ideas', to: 'ideas#index'
      
      # Users
      get '/users/:id', to: 'users#show' 
      post '/users', to: 'users#create'
    end
  end
end
