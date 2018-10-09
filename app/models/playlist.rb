class Playlist < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many :ratings, as: :rateable
  has_and_belongs_to_many :songs

  validates_presence_of :title, :description

  scope :owned_by, ->(user, playlist_id) { where(owner: user, id: playlist_id) }
  scope :user_playlist, ->(user) { where(owner: user) }

  class << self
    def create_playlist(params)
      new_playlist = new(params)

      new_playlist.save

      new_playlist
    end

    def add_songs_to_playlist(playlist_object)
      playlist = find_by(id: playlist_object[:id])
      playlist.songs = playlist_object[:songs]

      playlist.save

      playlist
    end

    def remove_songs_to_playlist(playlist_object)
      song_ids = playlist_object[:songs].pluck(:id)
      playlist = find_by(id: playlist_object[:id])
      playlist.song_ids = playlist.song_ids - song_ids

      playlist.save

      playlist
    end
  end
end
