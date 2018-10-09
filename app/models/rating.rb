class Rating < ApplicationRecord
  EXCELLENT = 5
  VERY_GOOD = 4
  GOOD      = 3
  FAIR      = 2
  POOR      = 1
  UNRATED   = 0

  belongs_to :rateable, polymorphic: true
  belongs_to :created_by, class_name: 'User', foreign_key: 'user_id'

  enum rating_score: {
    unrated: UNRATED,
    poor: POOR,
    fair: FAIR,
    good: GOOD,
    very_good: VERY_GOOD,
    excellent: EXCELLENT
  }

  validates_presence_of :rating_score

  class << self
    def update_rating_score(rating_object)
      rating = find_or_initialize_by(
        created_by: rating_object[:created_by],
        rateable: rating_object[:rateable]
      )

      rating.rating_score = rating_object[:rating_score]
      rating.created_by = rating_object[:created_by]
      rating.rateable = rating_object[:rateable_type]
      rating.save

      rating
    end

    def delete_rating_resource(rating_id)
      rating = find_by(id: rating_id)

      if rating.present?
        rating.rating_score = UNRATED
        rating.save
      end
    end
  end
end
