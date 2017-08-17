class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, styles: { medium: "200x200#", thumb: "100x100#" }, default_url: "missing.jpg"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  validates_presence_of :name

  has_many :chatroom_users
  has_many :chatrooms, through: :chatroom_users
  has_many :messages

  scope :all_except, ->(user) { where.not(id: user) }
  #scope :not_in_chat, ->(chatroom) { where.not() }

  before_save :capitalize_name

  def capitalize_name
    self.name = self.name.titleize
  end

  def update_without_password(params, *options)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end
    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end  

  def self.other_user_name(chatroom)
    user = chatroom.chatroom_users.map(&:user_id).delete_if { |i| i == self.id }
    User.find_by_id(user).name
  end
end
