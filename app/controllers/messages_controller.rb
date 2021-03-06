class MessagesController < ApplicationController
  before_action :set_chatroom

  def create
    message = @chatroom.messages.new(message_params)
    message.user = current_user
    if message.save
      MessageRelayJob.perform_later(message)
      redirect_to chatroom_path(@chatroom)
    else
      redirect_to :back, alert: 'Something went wrong'
    end
  end

  private

  def set_chatroom
    @chatroom = Chatroom.find(params[:chatroom_id])
  end

  def message_params
    params.require(:message).permit(:body)
  end
end