class Rating < ApplicationRecord
  EXCELLENT = 5
  VERY_GOOD = 4
  GOOD      = 3
  FAIR      = 2
  POOR      = 1
  UNRATED   = 0

  belongs_to :rateable, polymorphic: true

  enum rating_score: { excellent: EXCELLENT,
                       very_good: VERY_GOOD,
                       good: GOOD,
                       fair: FAIR,
                       poor: POOR,
                       unrated: UNRATED }

  validates_presence_of :rating_score
end
