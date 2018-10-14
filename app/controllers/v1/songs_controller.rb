module V1
  class SongsController < ApplicationController
    include Concerns::Uploads

    load_and_authorize_resource class: 'Song'
    skip_authorize_resource only: [:update_play_count]
    before_action :find_song_by_id, only: [:show, :update, :destroy, :perform_upload, :update_play_count]
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

    def update_play_count
      return unprocessable_entity_error unless @song.update_play_count

      custom_success_response(message: 'Song count updated')
    end

    def perform_upload
      delete_item
      song_resource = upload_file

      return custom_error({ message: 'Upload did not succeed, try again!' }, status: 500) unless song_resource

      @song.update_attributes(update_payload(song_resource))

      return unprocessable_entity_error unless @song

      custom_success_response(@song)
    end

    private

    def song_params
      params.require(:song)
        .permit(:title, :track, :genre, :artist, :album_id)
        .merge(created_by: current_user, album: find_album)
    end

    def find_song_by_id
      @song = Song.find_by_id(params[:id])

      not_found if @song.nil?
    end

    def find_album
      Album.find_by_id(params[:song][:album_id])
    end

    def delete_item
      delete_file if @song["#{params[:type]}_url"].present?
    end

    def resource_option
      @song
    end

    def url
      url_param
    end

    def url_param
      return params[:image_url] if params[:type] == 'image'

      params[:song_url]
    end

    def update_payload(resource)
      if params[:type] == 'image'
        { image_url: resource['url'], image_public_id: resource['public_id'] }
      else
        { song_url: resource['url'], song_public_id: resource['public_id'] }
      end
    end
  end
end
