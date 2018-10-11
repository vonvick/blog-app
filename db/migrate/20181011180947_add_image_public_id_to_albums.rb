class AddImagePublicIdToAlbums < ActiveRecord::Migration[5.1]
  def change
    add_column :albums, :image_public_id, :string
  end
end
