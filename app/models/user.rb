# frozen_string_literal: true

class User < ActiveRecord::Base
  belongs_to :role, foreign_key: 'role_id', optional: true
  has_many :albums, foreign_key: 'user_id'
  has_many :playlists, foreign_key: 'user_id'
  has_many :songs, foreign_key: 'user_id'

  before_create :default_role
  before_validation :assign_uid

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates_presence_of :first_name, :last_name, :username, :email
  validates_uniqueness_of :email, :username
  validates :first_name, :last_name, :username, length: { minimum: 2 }
  validates :description, length: { maximum: 500 }
  validates :password, length: { in: 6..20 }
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/ }
  validate :same_as_email?
  validates_associated :playlists


  def same_as_email?
    errors.add(:uid, 'must match email') unless uid == email
  end

  def assign_uid
    self.uid = email
  end

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
