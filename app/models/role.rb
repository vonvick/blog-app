class Role < ApplicationRecord
  has_many :users, foreign_key: 'role_id'

  validates_presence_of :title, :rank
end
