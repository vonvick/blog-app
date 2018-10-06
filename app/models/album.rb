class Album < ApplicationRecord
  # has_many :ratings, as: rateable
  belongs_to :created_by, class_name: 'User', foreign_key: 'user_id'

  validates_presence_of :title, :description, :artist, :year
end
