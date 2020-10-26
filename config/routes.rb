Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users do
      end
      resources :trails do
        collection do
          post :changeOrder
        end
      end
    end
  end
  post 'authenticate', to: 'authentication#authenticate'
end
