class ChatroomsController < ApplicationController
  include ApplicationHelper
  before_action :set_chatroom, only: [:show, :edit, :update, :destroy]

  def index
    @chatrooms = current_user.chatrooms
  end

  def show
    @chatroom_user = current_user.chatroom_users.find_by(chatroom_id: @chatroom.id)
  end

  def new
    @chatroom = current_user.chatrooms.new
    @chatroom.chatroom_users.new
  end

  def edit
  end

  def create
    @chatroom = current_user.chatrooms.new(chatroom_params)
    user_ids = params['chatroom']['chatroom_users_attributes']["0"]["user_id"].reject(&:blank?)
    user_ids << current_user.id.to_s
    if user_ids.size <= 2 && chatroom_params[:name].blank?
      @chatroom.name = user_ids.sort.join + 'one-to-one'
    end
    respond_to do |format|
      if @chatroom.save
        user_ids.each do |user_id|
          @chatroom.chatroom_users.create(chatroom_id: @chatroom.id, user_id: user_id.to_i, last_read_at: Time.zone.now)
        end
        format.html { redirect_to @chatroom, notice: 'Chatroom was successfully created.' }
        format.json { render :show, status: :created, location: @chatroom }
      else
        format.html { render :new }
        format.json { render json: @chatroom.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    users_in_chat = @chatroom.chatroom_users.map(&:user_id)
    user_ids = []
    params['chatroom']['chatroom_users_attributes'].permit!.to_h.values.each do |form|
      user_ids << form["user_id"].reject(&:blank?)
    end
    new_users = user_ids.flatten.map(&:to_i) - users_in_chat
    respond_to do |format|
      if @chatroom.update(chatroom_params)
        new_users.each do |user_id|
          @chatroom.chatroom_users.create(chatroom_id: @chatroom.id, user_id: user_id.to_i)
        end
        format.html { redirect_to @chatroom, notice: 'Chatroom was successfully updated.' }
        format.json { render :show, status: :ok, location: @chatroom }
      else
        format.html { render :edit }
        format.json { render json: @chatroom.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @chatroom.destroy
    respond_to do |format|
      format.html { redirect_to chatrooms_url, notice: 'Chatroom was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chatroom
      @chatroom = Chatroom.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chatroom_params
      params.require(:chatroom).permit(:name, :chatroom_users_attributes)
    end
end
