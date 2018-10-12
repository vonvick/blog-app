class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :artist, :year, :image_url, :created_at, :updated_at

  belongs_to :created_by, class_name: 'User'
  has_many :ratings
  has_many :songs
end
