class SongSerializer < ActiveModel::Serializer
  attributes :id,
             :title,
             :track,
             :artist,
             :genre,
             :play_count,
             :image_url,
             :song_url,
             :created_at,
             :updated_at

  belongs_to :album
  belongs_to :created_by
  belongs_to :ratings
end
