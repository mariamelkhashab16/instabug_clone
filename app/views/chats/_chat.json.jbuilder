json.extract! chat, :id, :application_id, :num, :msgs_count, :created_at, :updated_at
json.url chat_url(chat, format: :json)
