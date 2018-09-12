Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Ideas
      resources :ideas, only: [:index, :show]
      
      # Users
      get '/users/:id', to: 'users#show' 
      post '/users', to: 'users#create'

      # Contributions
      post '/ideas/:id/contributions', to: 'contributions#create'
      patch '/contributions/:id', to: 'contributions#edit'

      # Comments
      post '/contributions/:id/comments', to: 'comments#create'
      patch '/comments/:id', to: 'comments#edit'
    end
  end
end
