module V1
  class AlbumsController < ApplicationController
    before_action :find_album_by_slug, only: [:show, :update, :destroy]

    def index
      @albums = Album.all

      render custom_response(message: @albums)
    end

    def create
      @album = Album.new(album_params)
      @album.user = current_user

      if @album.save
        render custom_success_response(data: @album)
      else
        render custom_error(message: 'An Error occurred while creating the album')
      end
    end

    def show
      render custom_success_response(data: @album) if @album.present?

      render json: not_found
    end

    def update
      @album.update_attributes(album_params)

      render custom_success_response(data: @album)
    end

    def destroy
      @album.destroy

      render custom_success_response(data: 'Album successfully deleted')
    end

    private

    def album_params
      params.require(:article).permit(:title, :description, :year, :artist)
    end

    def find_album_by_slug
      @album = Album.find_by_title(params[:title])
    end
  end
end
