module V1
  class AlbumsController < ApplicationController
    before_action :find_album_by_slug, only: [:show, :update, :destroy]

    def index
      @albums = Album.all

      render custom_success_response(data: @albums)
    end

    def create
      @album = Album.save_album(album_params)

      return render custom_error(message: 'An Error occurred while creating the album') if @album.nil?

      render custom_success_response(status: :created, data: @album)
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
      params.require(:album)
        .permit(:title, :description, :year, :artist)
        .merge(created_by: current_user)
    end

    def find_album_by_slug
      @album = Album.find_by_id(params[:id])

      return render json: not_found if @album.nil?

      @album
    end
  end
end
