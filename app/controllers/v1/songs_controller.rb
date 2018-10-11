module V1
  class SongsController < ApplicationController
    load_and_authorize_resource class: 'Song'
    before_action :find_song_by_slug, only: [:show, :update, :destroy]
    before_action :find_album, only: [:create, :update]

    def index
      @songs = Song.all

      custom_success_response(@songs)
    end

    def create
      @song = Song.save_song(song_params)

      return custom_error(message: 'Could not create song') if @song.nil?

      custom_success_response(@song, status: :created)
    end

    def show
      custom_success_response(@song)
    end

    def update
      return unprocessable_entity_error unless @song.update_attributes(song_params)

      custom_success_response(@song)
    end

    def destroy
      return unprocessable_entity_error unless @song.destroy

      custom_success_response(message: 'Song successfully deleted')
    end

    private

    def song_params
      params.require(:song)
        .permit(:title, :track, :genre, :artist, :album_id)
        .merge(created_by: current_user, album: find_album)
    end

    def find_song_by_slug
      @song = Song.find_by_id(params[:id])

      not_found if @song.nil?
    end

    def find_album
      Album.find_by_id(params[:song][:album_id])
    end
  end
end
