class AddImageUrlToPlaylists < ActiveRecord::Migration[5.1]
  def change
    add_column :playlists, :image_url, :string
  end
end
