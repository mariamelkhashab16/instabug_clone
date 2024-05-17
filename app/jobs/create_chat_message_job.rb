class CreateChatMessageJob < ApplicationJob
  queue_as :default

  def perform(chat, message_content)
    chat.with_lock do
      # Create the message
      current_msg_count = chat.msgs_count
      new_msg_num = current_msg_count + 1
      msg = chat.messages.new(msg_no: new_msg_num, content: message_content)

      # Save the message
      if msg.save
        chat.increment!(:msgs_count)
        return msg.reload  # Return the new message number if message creation is successful
      else
        # Handle error if message creation fails
        Rails.logger.error "Failed to create chat message: #{msg.errors.full_messages.to_sentence}"
        return nil
      end
    end
  end
end
