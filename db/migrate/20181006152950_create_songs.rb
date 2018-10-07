class CreateSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :songs do |t|
      t.string      :title
      t.text        :track
      t.string      :artist
      t.integer     :genre
      t.integer     :play_count, default: 0
      t.references  :album, foreign_key: true
      t.references  :user, foreign_key: true

      t.timestamps
    end
  end
end
