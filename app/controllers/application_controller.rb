class ApplicationController < ActionController::API
  respond_to :json

  include CanCan::ControllerAdditions
  include Concerns::CommonResponses
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Concerns::Devise::Auth

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    render json: forbidden(exception.message)
  end
end
