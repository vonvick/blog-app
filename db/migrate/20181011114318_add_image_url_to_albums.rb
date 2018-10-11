class AddImageUrlToAlbums < ActiveRecord::Migration[5.1]
  def change
    add_column :albums, :image_url, :string
  end
end
