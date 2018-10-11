class AddImageAndSongsPublicIdToSongs < ActiveRecord::Migration[5.1]
  def change
    add_column :songs, :image_public_id, :string
    add_column :songs, :song_public_id, :string
    add_column :songs, :song_url, :string
  end
end
