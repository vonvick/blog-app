module V1
  class RatingsController < ApplicationController
    load_and_authorize_resource 'Rating'
    skip_authorize_resource only: [:edit_ratings_resource]
    include Concerns::Ratings

    before_action :prepare_ratings_object, only: [:edit_ratings_resource]
    before_action :ratings_params, only: [:edit_ratings_resource]

    def edit_ratings_resource
      authorize! :rate, params[:rating][:rateable_type].to_sym
      @rating = Rating.update_rating_score(prepare_ratings_object)

      if @rating
        custom_success_response(@rating)
      else
        custom_error(@rating)
      end
    end

    def destroy
      @rating = Rating.delete_rating_resource(params[:id])

      return unprocessable_entity_error if @rating.nil?

      custom_success_response(data: 'Rating successfully removed')
    end

    private

    def ratings_params
      params.require(:rating).permit(:rating_score, :rateable_type, :rateable_id, :id)
    end

    def prepare_ratings_object
      {
        created_by: current_user,
        rateable: rateable_class,
        rating_score: params[:rating][:rating_score]
      }
    end
  end
end
