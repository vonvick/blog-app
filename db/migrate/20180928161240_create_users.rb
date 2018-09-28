class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :email
      t.string :password
      t.string :image_url, null: true
      t.string :job_title
      t.references :role, foreign_key: true
      t.text :description
      t.string :phone_number
      t.datetime :last_login

      t.timestamps
    end
  end
end
