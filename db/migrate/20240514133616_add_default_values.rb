class AddDefaultValues < ActiveRecord::Migration[7.1]
  def change
  change_column_default :applications, :chats_count, 0
  change_column_default :chats, :msgs_count, 0
  change_column_default :chats, :num, 0

  end
end
