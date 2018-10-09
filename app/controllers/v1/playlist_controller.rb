module V1
  class PlaylistController < ApplicationController
    before_action :find_playlist_by_slug, only: [:show, :update, :destroy]
    before_action :check_playlist_owner, only: [:update, :destroy, :add_song, :remove_song]

    def index
      @playlist = Playlist.all

      render custom_success_response(data: @playlist)
    end

    def create
      @playlist = Playlist.create_playlist(playlist_params)

      return render custom_error(message: 'An Error occurred while creating the playlist') if @playlist.nil?

      render custom_success_response(status: :created, data: @playlist)
    end

    def show
      return render json: not_found if @playlist.nil?

      render custom_success_response(data: @playlist)
    end

    def update
      if @playlist.update_attributes(playlist_params)
        render custom_success_response(data: @playlist)
      else
        render unprocessable_entity_error
      end
    end

    def destroy
      return render unprocessable_entity_error unless @playlist.destroy

      render custom_success_response(data: 'playlist successfully deleted')
    end

    def user_playlists
      @playlist = Playlist.user_playlist(current_user)

      render custom_success_response(data: @playlist)
    end

    def add_songs
      @playlist = Playlist.add_songs_to_playlist(find_associated_songs)

      return render unprocessable_entity_error unless @playlist

      render custom_success_response(data: @playlist)
    end

    def remove_songs
      @playlist = Playlist.remove_songs_to_playlist(find_associated_songs)

      return render unprocessable_entity_error unless @playlist

      render custom_success_response(data: @playlist)
    end

    private

    def playlist_params
      params.require(:playlist)
        .permit(:title, :description, song_ids: [])
        .merge(owner: current_user)
    end

    def find_playlist_by_slug
      @playlist = Playlist.find_by_id(params[:id])

      render json: not_found if @playlist.nil?
    end

    def check_playlist_owner
      playlist_owner = Playlist.owned_by(current_user, params[:id])

      render json: forbidden unless playlist_owner.exists?
    end

    def find_associated_songs
      songs = Song.where(id: params[:playlist][:song_ids])

      {
        id: params[:id],
        songs: songs
      }
    end
  end
end
