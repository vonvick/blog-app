module V1
  class SongsController < ApplicationController
    before_action :find_song_by_slug, only: [:show, :update, :destroy]

    def index
      @songs = Song.all

      render custom_response(message: @songs)
    end

    def create
      @song = Song.new(album_params)
      @song.user = current_user

      if @song.save
        render custom_success_response(data: @song)
      else
        render custom_error(message: 'An Error occurred while creating the song')
      end
    end

    def show
      render custom_success_response(data: @song) if @song.present?

      render json: not_found
    end

    def update
      if @song.update_attributes(album_params)
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
      params.require(:song).permit(:title, :track, :genre, :artist, album: [])
    end

    def find_song_by_slug
      @song = Song.find_by_title(params[:title])
    end
  end
end
