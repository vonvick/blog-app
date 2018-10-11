class PlaylistSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :created_at, :updated_at

  belongs_to :owner
  has_many :ratings
  has_many :songs
end
