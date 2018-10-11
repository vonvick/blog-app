module V1
  class AlbumsController < ApplicationController
    include Concerns::Uploads

    load_and_authorize_resource class: 'Album'
    before_action :find_album_by_slug, only: [:show, :update, :destroy, :perform_upload]

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
      update_album = @album.update_attributes!(album_params)

      return custom_success_response(@album) if update_album

      unprocessable_entity_error
    end

    def destroy
      return unprocessable_entity_error unless @album.destroy

      custom_success_response(message: 'Album successfully deleted')
    end

    def perform_upload
      delete_image
      album_image = upload_file

      return custom_error({ message: 'Upload did not succeed, try again!' }, status: 500) unless album_image

      @album.update_attributes(
        image_url: album_image['url'], image_public_id: album_image['public_id']
      )

      return unprocessable_entity_error unless @album

      custom_success_response(@album)
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

    def delete_image
      delete_file if @album.image_url.present?
    end

    def resource_option
      @album
    end

    def url
      params[:image_url]
    end
  end
end
