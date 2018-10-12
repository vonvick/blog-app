module V1
  class PlaylistController < ApplicationController
    include Concerns::Uploads

    load_and_authorize_resource class: 'Playlist'
    before_action :find_playlist_by_slug, only: [:show, :update, :destroy]
    before_action :check_playlist_owner, only: [:update, :destroy, :add_songs, :remove_songs, :upload_images]

    def index
      @playlist = Playlist.all

      custom_success_response(@playlist)
    end

    def create
      @playlist = Playlist.create_playlist(playlist_params)

      return custom_error(message: 'An Error occurred while creating the playlist') if @playlist.nil?

      custom_success_response(@playlist, status: :created)
    end

    def show
      custom_success_response(@playlist)
    end

    def update
      return unprocessable_entity_error unless @playlist.update_attributes(playlist_params)

      custom_success_response(@playlist)
    end

    def destroy
      return unprocessable_entity_error unless @playlist.destroy

      custom_success_response(data: 'playlist successfully deleted')
    end

    def user_playlists
      @playlist = Playlist.user_playlist(current_user)

      custom_success_response(@playlist)
    end

    def upload_images
      delete_image
      playlist_image = upload_file

      return custom_error({ message: 'Upload did not succeed, try again!' }, status: 500) unless playlist_image

      @playlist.update_attributes(
        image_url: playlist_image['url'], image_public_id: playlist_image['public_id']
      )

      return unprocessable_entity_error unless @playlist

      custom_success_response(@playlist)
    end

    def add_songs
      @playlist = Playlist.add_songs_to_playlist(find_associated_songs)

      return unprocessable_entity_error unless @playlist

      custom_success_response(@playlist)
    end

    def remove_songs
      @playlist = Playlist.remove_songs_to_playlist(find_associated_songs)

      return unprocessable_entity_error unless @playlist

      custom_success_response(@playlist)
    end

    private

    def playlist_params
      params.require(:playlist)
        .permit(:title, :description, song_ids: [])
        .merge(owner: current_user)
    end

    def find_playlist_by_slug
      @playlist = Playlist.find_by_id(params[:id])

      not_found if @playlist.nil?
    end

    def check_playlist_owner
      playlist_owner = Playlist.owned_by(current_user, params[:id])

      forbidden(message: 'No playlist for this user yet') unless playlist_owner.exists?
    end

    def find_associated_songs
      songs = Song.where(id: params[:playlist][:song_ids])

      {
        id: params[:id],
        songs: songs
      }
    end

    def delete_image
      delete_file if @playlist.image_url.present?
    end

    def resource_option
      @playlist
    end

    def url
      params[:image_url]
    end
  end
end
