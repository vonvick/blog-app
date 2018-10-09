module V1
  class SongsController < ApplicationController
    before_action :find_song_by_slug, only: [:show, :update, :destroy]

    def index
      @songs = Song.all

      render custom_success_response(data: @songs)
    end

    def create
      @song = Song.new(song_params)
      @song.created_by = current_user

      if @song.save
        render custom_success_response(data: @song)
      else
        render custom_error(message: @song.errors)
      end
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
      params.require(:song).permit(:title, :track, :genre, :artist, :album_id)
    end

    def find_song_by_slug
      @song = Song.find_by_id(params[:id])

      return render json: not_found if @song.nil?

      @song
    end
  end
end
