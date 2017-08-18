class CreateChatroomUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :chatroom_users do |t|
      t.references :chatroom, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_column :chatroom_users, :last_read_at, :datetime
  end
end
