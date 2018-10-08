Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks], controllers: {
    registrations: 'v1/auth/registrations',
    sessions: 'v1/auth/sessions'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1, defaults: { format: :json } do
    resources :albums
    resources :songs
    resources :ratings, only: [:destroy] do
      put :set_ratings_resource
    end
  end
end
