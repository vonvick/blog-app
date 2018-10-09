module V1
  class RatingsController < ApplicationController
    include Concerns::Ratings

    before_action :prepare_ratings_object, only: [:edit_ratings_resource]

    def edit_ratings_resource
      @rating = Rating.update_rating_score(prepare_ratings_object)

      if @rating
        render custom_success_response(data: @rating)
      else
        render custom_error(message: @rating)
      end
    end

    def destroy
      @rating = Rating.delete_rating_resource(params[:id])

      return render unprocessable_entity_error if @rating.nil?

      render custom_success_response(data: 'Rating successfully removed')
    end

    private

    def prepare_ratings_object
      {
        created_by: current_user,
        rateable: rateable_class,
        rating_score: params[:rating_score]
      }
    end
  end
end
