module ApplicationHelper
  def other_user_name(chatroom)
    user = chatroom.chatroom_users.map(&:user_id).delete_if { |i| i == current_user.id }
    User.find_by_id(user).name
  end

  def other_user_avatar(chatroom)
    user = chatroom.chatroom_users.map(&:user_id).delete_if { |i| i == current_user.id }
    User.find_by_id(user).avatar.url
  end

  def inbox(user)
    last_messages = []
    user.chatrooms.each do |chatroom|
      last_messages << chatroom.messages.last
    end
    last_message = last_messages.compact.max_by(&:created_at)
    unless last_message.nil?
    	if user.chatroom_users.where(chatroom_id: last_message.chatroom_id).first.last_read_at < last_message.created_at
    		return true
    	else
    		return false
    	end
    else
      return false
    end
  end
end
