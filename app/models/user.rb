# frozen_string_literal: true

class User < ActiveRecord::Base
  belongs_to :role, foreign_key: 'role_id', optional: true
  has_many :albums, foreign_key: 'user_id'
  has_many :playlists, foreign_key: 'user_id'
  has_many :songs, foreign_key: 'user_id'

  before_create :default_role

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates_presence_of :first_name, :last_name, :username, :email, :uid
  validates_uniqueness_of :email, :username

  def role?
    role.title
  end

  def default_role
    self.role = if User.count < 1
                  Role.find_by_title('admin')
                else
                  Role.find_by_title('user')
                end
  end
end
