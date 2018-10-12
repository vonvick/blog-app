class ChangeImageUrlToAvatar < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :image_url, :avatar
  end
end
