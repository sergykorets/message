class ChatroomUser < ApplicationRecord
  belongs_to :chatroom
  belongs_to :user

  validates_uniqueness_of :chatroom_id, scope: :user_id, message: 'User is already in this conversation'
end
