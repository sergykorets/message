class Chatroom < ApplicationRecord
  has_many :chatroom_users
  has_many :users, through: :chatroom_users
  has_many :messages

  accepts_nested_attributes_for :chatroom_users

  validates_presence_of :name
  validates_uniqueness_of :name, message: 'This conversation already exists'
end
