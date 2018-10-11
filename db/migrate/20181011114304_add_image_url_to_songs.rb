class AddImageUrlToSongs < ActiveRecord::Migration[5.1]
  def change
    add_column :songs, :image_url, :string
  end
end
