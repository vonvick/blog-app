class Rating < ApplicationRecord
  EXCELLENT = 5
  VERY_GOOD = 4
  GOOD      = 3
  FAIR      = 2
  POOR      = 1
  UNRATED   = 0

  belongs_to :rateable, polymorphic: true
  belongs_to :created_by, class_name: 'User', foreign_key: 'user_id'

  enum rating_score: [UNRATED, POOR, FAIR, GOOD, VERY_GOOD, EXCELLENT]

  validates_presence_of :rating_score

  class << self
    def update_rating_score(rating_object)
      rating = find_or_initialize_by(
        user_id: rating_object[:user_id],
        rateable_id: rating_object[:rateable_id],
        rateable_type: rating_object[:type]
      )

      rating.rating_score = rating_object[:rating_score]

      rating.save
    end

    def delete_rating_resource(rating_object)
      rating = find_by(id: rating_object[:id])

      if rating.present?
        rating.rating_score = UNRATED
        rating.save
      else
        error.add(:id, 'Could not find rating for this resource by this user')
      end
    end
  end
end
