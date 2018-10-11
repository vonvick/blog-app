class AddImagePublicIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :image_public_id, :string
  end
end
