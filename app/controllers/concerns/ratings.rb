module Concerns
  module Ratings
    extend ActiveSupport::Concern

    def rateable_class
      rateable = params[:rateable_type].capitalize
      rateable.constantize
    end
  end
end