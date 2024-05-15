class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :chat

  # Define Elasticsearch index settings and mappings
  settings index: { number_of_shards: 1 } do
    mappings dynamic: false do
      indexes :content, type: 'text'
    end
  end

  # Customize the JSON representation of your model for indexing
  def as_indexed_json(options = {})
    self.as_json(only: [:content])
  end

Message.__elasticsearch__.create_index! force: true
Message.import
end
