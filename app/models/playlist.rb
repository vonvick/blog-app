class Playlist < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many :ratings, as: :rateable
  has_and_belongs_to_many :songs

  validates_presence_of :title, :description

  # class << self
  #   def save_playlist(params)
  #     new_album = new(params)
  #
  #     new_album.save
  #
  #     new_album
  #   end
  # end
end
