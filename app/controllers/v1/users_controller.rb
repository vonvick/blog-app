module V1
  class UsersController < ApplicationController
    include Concerns::Uploads

    load_and_authorize_resource class: 'User'
    before_action :find_user_by_slug, only: [:show, :destroy, :set_avatar]

    def index
      @users = User.all

      custom_success_response(@users)
    end

    def show
      custom_success_response(@user)
    end

    def destroy
      return unprocessable_entity_error unless @user.destroy

      custom_success_response(data: 'User successfully deleted')
    end

    def set_avatar
      delete_image

      avatar = upload_file

      return custom_error({ message: 'Upload did not succeed, try again!' }, status: 500) unless avatar

      updated_attribute = @user.update_attributes(avatar: avatar['url'], image_public_id: avatar['public_id'])
      return custom_success_response(@user) if updated_attribute

      unprocessable_entity_error
    end

    private

    def find_user_by_slug
      @user = User.find_by_id(params[:id])

      not_found if @user.nil?
    end

    def user_params
      params.permit(:avatar)
    end

    def delete_image
      delete_file if @user.avatar.present?
    end

    def resource_option
      @user
    end

    def url
      params[:avatar]
    end
  end
end
