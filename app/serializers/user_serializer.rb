class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :first_name,
             :last_name,
             :username,
             :email,
             :uid,
             :description,
             :headline,
             :avatar,
             :created_at,
             :updated_at

  belongs_to :role
  has_many :playlists
  has_many :songs
  has_many :albums
end
