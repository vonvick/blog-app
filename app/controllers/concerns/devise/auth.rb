module Concerns
  module Devise
    module Auth
      extend ActiveSupport::Concern

      def configure_permitted_parameters # rubocop:disable Metrics/MethodLength
        added_attrs = [
          :username,
          :email,
          :password,
          :password_confirmation,
          :remember_me,
          :role_id,
          :first_name,
          :last_name,
          :uid
        ]

        devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
        devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
      end
    end
  end
end
