class Album < ApplicationRecord
  belongs_to :created_by, class_name: 'User', foreign_key: 'user_id'
  has_many :ratings, as: :rateable
  has_many :songs

  validates_presence_of :title, :description, :artist, :year
end
