# Concern to encapsulate common errors to return via API
module Concerns
  module CommonResponses
    extend ActiveSupport::Concern

    def common_response(type = nil)
      return custom_success_response(message: 'Operation successful') if type.blank?

      send(type.to_s.to_sym)
    end

    def custom_success_response(data, status: 200, success: true)
      _custom_response(data, success: success, status: status)
    end

    def custom_error(data, status: 400, success: false)
      _custom_response(data, success: success, status: status)
    end

    def _custom_response(data, success:, status:)
      render json: data, adapter: :json, status: status, success: success
    end

    def server_error
      _custom_response({ error: 'An internal Server error occurred' }, success: 500, status: false)
    end

    def forbidden(message)
      _custom_response(
        { error: message },
        success: :forbidden,
        status: false
      )
    end

    def not_found(message: 'Resource not found')
      _custom_response({ error: message }, success: :not_found, status: false)
    end

    def unprocessable_entity_error
      _custom_response(
        { error: 'Request could not be processed' },
        success: :unprocessable_entity,
        status: false
      )
    end
  end
end
