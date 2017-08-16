class ChatroomsController < ApplicationController
  before_action :set_chatroom, only: [:show, :edit, :update, :destroy]

  def index
    @chatrooms = current_user.chatrooms.paginate(:page => params[:page], :per_page => 6)
  end

  def show
    @chatroom_user = current_user.chatroom_users.find_by(chatroom_id: @chatroom.id)
  end

  def new
    @chatroom = Chatroom.new
    @chatroom.chatroom_users.new
  end

  def edit
  end

  def create
    @chatroom = current_user.chatrooms.new(chatroom_params)
    user_ids = params['chatroom']['chatroom_users_attributes']["0"]["user_id"].reject(&:blank?)
    if user_ids.size < 2 && chatroom_params[:name].blank?
      @chatroom.name = current_user.email
    end
    respond_to do |format|
      if @chatroom.save
        @chatroom.chatroom_users.create(chatroom_id: @chatroom.id, user_id: current_user.id)
        user_ids.each do |user_id|
          @chatroom.chatroom_users.create(chatroom_id: @chatroom.id, user_id: user_id.to_i)
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
    respond_to do |format|
      if @chatroom.update(chatroom_params)
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
