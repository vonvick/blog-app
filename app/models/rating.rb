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
end
