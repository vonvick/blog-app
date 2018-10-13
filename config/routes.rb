Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks], controllers: {
    registrations: 'v1/auth/registrations',
    sessions: 'v1/auth/sessions'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1, defaults: { format: :json } do
    resources :albums do
      put '/:rateable_type/ratings' => 'ratings#edit_ratings_resource'
      put '/upload_image' => 'albums#perform_upload'
    end
    resources :songs do
      collection do
        put '/:song_id/:rateable_type/ratings' => 'ratings#edit_ratings_resource'
        put '/:id/upload/:type' => 'songs#perform_upload'
        put '/:id/play_count' => 'songs#update_play_count'
      end
    end
    resources :ratings, only: [:destroy]
    resources :playlist do
      collection do
        get '/user/:user_id' => 'playlist#user_playlists'
        put '/add_song/:id' => 'playlist#add_songs'
        delete '/remove_song/:id' => 'playlist#remove_songs'
        put '/:id/ratings' => 'ratings#edit_ratings_resource'
        put '/:id/upload_image' => 'playlist#upload_image'
      end
    end
    resources :users, only: [:index, :show, :destroy] do
      collection do
        put '/:id/set_avatar' => 'users#set_avatar'
      end
    end
  end
end
