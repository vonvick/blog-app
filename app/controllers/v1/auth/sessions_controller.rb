module V1
  module Auth
    class SessionsController < DeviseTokenAuth::SessionsController
      # skip_before_action :authenticate_user!, only: [:create]

      def create
        render json: { data: @resource }
      end
    end
  end
end
