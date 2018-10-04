class ApplicationController < ActionController::API
  respond_to :json

  include DeviseTokenAuth::Concerns::SetUserByToken
  include Concerns::Devise::Auth

  before_action :configure_permitted_parameters, if: :devise_controller?
end
