module ApplicationHelper
  def other_user_name(chatroom)
    user = chatroom.chatroom_users.map(&:user_id).delete_if { |i| i == current_user.id }
    User.find_by_id(user).name
  end

  def other_user_avatar(chatroom)
    user = chatroom.chatroom_users.map(&:user_id).delete_if { |i| i == current_user.id }
    User.find_by_id(user).avatar.url
  end 
end
