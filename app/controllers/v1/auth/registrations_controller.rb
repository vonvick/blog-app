module V1
  module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      skip_before_action :authenticate_user!

      private

      def account_update_params
        if params[@devise_mapping.name][:password_confirmation].blank?
          params[@devise_mapping.name].delete(:password)
          params[@devise_mapping.name].delete(:password_confirmation)
        end

        super
      end
    end
  end
end
