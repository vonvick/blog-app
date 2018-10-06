class CreateAlbums < ActiveRecord::Migration[5.1]
  def change
    create_table :albums do |t|
      t.string      :title
      t.text        :description
      t.string      :artist
      t.integer     :year
      t.references  :user, foreign_key: true

      t.timestamps
    end
  end
end
