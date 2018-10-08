module V1
  class RatingsController < ApplicationController
    before_action :prepare_ratings_object

    def edit_ratings_resource
      @rating = Rating.update_rating_score(prepare_ratings_object)

      if @rating
        render custom_success_response(data: @rating)
      else
        render custom_error(message: 'An Error occurred while setting rating')
      end

    end

    def destroy
      @rating = Rating.delete_rating_resource(params[:id])

      if @rating.error?
        render unprocessable_entity_error
      else
        render custom_success_response(data: 'Rating successfully removed')
      end
    end

    private

    def prepare_ratings_object
      {
        user_id: current_user.id,
        rateable_id: params[:rateable_id],
        rateable_type: params[:type],
        rating_score: params[:rating_score]
      }
    end
  end
end