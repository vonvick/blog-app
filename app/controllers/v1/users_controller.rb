module V1
  class UsersController < ApplicationController
    load_and_authorize_resource class: 'User'
    before_action :find_user_by_slug, only: [:show, :destroy]

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

    private

    def find_user_by_slug
      @song = User.find_by_id(params[:id])

      not_found if @song.nil?
    end
  end
end
