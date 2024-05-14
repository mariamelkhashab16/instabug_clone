json.extract! message, :id, :chat_id, :msg_no, :content, :created_at, :updated_at
json.url message_url(message, format: :json)
