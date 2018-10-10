module V1
  class SongsController < ApplicationController
    load_and_authorize_resource class: 'Song'
    before_action :find_song_by_slug, only: [:show, :update, :destroy]
    before_action :find_album, only: [:create, :update]

    def index
      @songs = Song.all

      render custom_success_response(data: @songs)
    end

    def create
      @song = Song.save_song(song_params)

      return render custom_error(message: 'Could not create song') if @song.nil?

      render custom_success_response(status: :created, data: @song)
    end

    def show
      return render json: not_found if @song.nil?

      render custom_success_response(data: @song) if @song.present?
    end

    def update
      if @song.update_attributes(song_params)
        render custom_success_response(data: @song)
      else
        render unprocessable_entity_error
      end
    end

    def destroy
      if @song.destroy
        render custom_success_response(data: 'Song successfully deleted')
      else
        render unprocessable_entity_error
      end
    end

    private

    def song_params
      params.require(:song)
        .permit(:title, :track, :genre, :artist, :album_id)
        .merge(created_by: current_user, album: find_album)
    end

    def find_song_by_slug
      @song = Song.find_by_id(params[:id])

      render json: not_found if @song.nil?
    end

    def find_album
      Album.find_by_id(params[:song][:album_id])
    end
  end
end
