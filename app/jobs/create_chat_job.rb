class CreateChatJob < ApplicationJob
  queue_as :default

  def perform(application)
    application.with_lock do
      current_chat_count = application.chats_count
      new_chat_num = current_chat_count + 1
      chat = application.chats.new(num: new_chat_num)
    
      if chat.save
        application.increment!(:chats_count)
        return new_chat_num
      else
        Rails.logger.error "Failed to create chat: #{msg.errors.full_messages.to_sentence}"
        return nil
      end
    end

  end
end
