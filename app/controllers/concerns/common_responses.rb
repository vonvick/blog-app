# Concern to encapsulate common errors to return via API
module Concerns
  module CommonResponses
    extend ActiveSupport::Concern

    def common_response(type = nil)
      return custom_response if type.blank?

      send(type.to_s.to_sym)
    end

    def custom_success_response(status: 200, success: true, data: 'Success')
      _custom_response(status: status, success: success, data: data)
    end

    def custom_error(status: 400, success: false, message: 'Error')
      _custom_response(status: status, success: success, data: message)
    end

    def _custom_response(status:, success:, data:)
      { status: status, json: { success: success, data: data } }
    end

    def server_error
      { status: 500, json: { message: 'Server Error' } }
    end

    def forbidden
      { status: 403, json: { success: false, message: 'Forbidden' } }
    end

    def not_found
      { status: 404, json: { success: false, message: 'Not Found' } }
    end

    def unprocessable_entity_error(status: :unprocessable_entity, success: false, message: 'could not process')
      { status: status, json: { success: success, message: message } }
    end
  end
end
