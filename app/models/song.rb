class Song < ApplicationRecord
  belongs_to :created_by, class_name: 'User', foreign_key: 'user_id'
  belongs_to :album, foreign_key: 'album_id'
  has_many :ratings, as: :rateable

  validates_presence_of :title, :track, :artist, :genre, :play_count

  class << self
    def save_song(params)
      new_song = new(params)

      new_song.save

      new_song
    end
  end
end
