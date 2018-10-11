module V1
  class AlbumsController < ApplicationController
    load_and_authorize_resource class: 'Album'
    before_action :find_album_by_slug, only: [:show, :update, :destroy]

    def index
      @albums = Album.all

      custom_success_response(@albums, status: :ok)
    end

    def create
      @album = Album.save_album(album_params)

      return render server_error if @album.nil?

      custom_success_response(@album, status: :created)
    end

    def show
      custom_success_response(@album, status: :ok)
    end

    def update
      return unprocessable_entity_error unless @album.update_attributes(album_params)

      custom_success_response(@album, status: :ok)
    end

    def destroy
      return unprocessable_entity_error unless @album.destroy

      custom_success_response(message: 'Album successfully deleted')
    end

    private

    def album_params
      params.require(:album)
        .permit(:title, :description, :year, :artist)
        .merge(created_by: current_user)
    end

    def find_album_by_slug
      @album = Album.find_by_id(params[:id])

      not_found if @album.nil?
    end
  end
end
