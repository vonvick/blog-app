class AddPlaylistPublicIdToPlaylists < ActiveRecord::Migration[5.1]
  def change
    add_column :playlists, :playlist_public_id, :string
  end
end
