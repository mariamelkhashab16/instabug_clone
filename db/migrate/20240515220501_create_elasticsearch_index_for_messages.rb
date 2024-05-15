class CreateElasticsearchIndexForMessages < ActiveRecord::Migration[6.0]
  def up
    Message.__elasticsearch__.create_index! force: true
  end

  def down
    Message.__elasticsearch__.delete_index!
  end
end
