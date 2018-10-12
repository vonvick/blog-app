class RatingSerializer < ActiveModel::Serializer
  attributes :id, :rating_score, :created_at, :updated_at

  belongs_to :created_by
  belongs_to :rateable, polymorphic: true
end
