module Concerns
  module Ratings
    extend ActiveSupport::Concern

    def rateable_class
      rateable = params[:rating][:rateable_type].capitalize.constantize
      rateable&.find_by_id(params[:rating][:rateable_id])
    end
  end
end
