class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.references :application, null: false, foreign_key: true
      t.integer :num, default:0 
      t.integer :msgs_count, default:0

      t.timestamps
    end
  end
end
