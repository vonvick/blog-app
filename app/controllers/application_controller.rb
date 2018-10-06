class ApplicationController < ActionController::API
  respond_to :json
  # before_action :authenticate_user!

  include DeviseTokenAuth::Concerns::SetUserByToken
  include Concerns::Devise::Auth
  include Concerns::CommonResponses

  before_action :configure_permitted_parameters, if: :devise_controller?
end
