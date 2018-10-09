module V1
  class AlbumsController < ApplicationController
    before_action :find_album_by_slug, only: [:show, :update, :destroy]

    def index
      @albums = Album.all

      render custom_success_response(data: @albums)
    end

    def create
      @album = Album.new(album_params)
      @album.created_by = current_user

      if @album.save
        render custom_success_response(data: @album)
      else
        render custom_error(message: 'An Error occurred while creating the album')
      end
    end

    def show
      return render json: not_found if @album.nil?

      render custom_success_response(data: @album)
    end

    def update
      if @album.update_attributes(album_params)
        render custom_success_response(data: @album)
      else
        render unprocessable_entity_error
      end
    end

    def destroy
      if @album.destroy
        render custom_success_response(data: 'Album successfully deleted')
      else
        render unprocessable_entity_error
      end
    end

    private

    def album_params
      params.require(:album).permit(:title, :description, :year, :artist)
    end

    def find_album_by_slug
      @album = Album.find_by_id(params[:id])

      return render json: not_found if @album.nil?

      @album
    end
  end
end
