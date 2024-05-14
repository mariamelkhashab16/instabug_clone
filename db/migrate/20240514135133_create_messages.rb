class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.integer :msg_no, default:0
      t.text :content

      t.timestamps
    end
  end
end