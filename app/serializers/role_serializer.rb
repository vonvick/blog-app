class RoleSerializer < ActiveModel::Serializer
  attributes :id, :title, :rank

  has_many :users
end
