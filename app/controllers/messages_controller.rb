class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_application, :set_chat
  before_action :set_chat

  # GET /messages or /messages.json
  def index
    @messages =@chat.messages
    @messages = @messages.map do |message|
      {
        num: message.msg_no,
        content: message.content,
        chat_num: message.chat.num,
        application_token: message.chat.application.token,
        created_at: message.created_at,
        updated_at: message.updated_at
      }
    end
    render json: @messages
  end

  # GET /messages/1 or /messages/1.json
  def show
    @message = @chat.messages.find_by(msg_no:params['msg_no'])
    respond_to do |format|
      format.json { render json: @message }
    end
  end


  # POST /messages or /messages.json
  def create
    message_content = message_params['content']
    # Enqueue a job to create the message asynchronously
    new_msg = CreateChatMessageJob.perform_now(@chat, message_content)  # Perform the job synchronously to retrieve the new message number
    if new_msg.present?
      result =  {
        num: new_msg.msg_no,
        content: new_msg.content,
        chat_num: new_msg.chat.num,
        application_token: new_msg.chat.application.token,
        created_at: new_msg.created_at,
        updated_at: new_msg.updated_at
      }
      render json: { message: "Message created successfully", new_message: result }, status: :created
    else
      render json: { error: 'Failed to create message' }, status: :unprocessable_entity
    end  
  end

  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.json { render :show, status: :ok, location: @message }
      else
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def search 
    filter = JSON.parse(request.body.read)
    search_by_content = filter['content']
    # @messages = @chat.messages.where("content LIKE ?", "%#{search_by_content}%") # rom search
    # elastic search
    @messages = @chat.messages.search({
      query: {
        bool: {
          filter: {
            term: {
              "chat_id": @chat.id
            }
          },
          must: {
            match: {
              "content": search_by_content
            }
          }
        }
      }
    }).records
      @messages = @messages.map do |message|
        {
          num: message.msg_no,
          content: message.content,
          chat_num: message.chat.num,
          application_token: message.chat.application.token,
          created_at: message.created_at,
          updated_at: message.updated_at
        }
      end
      render json: @messages
  end
  # DELETE /messages/1 or /messages/1.json

  def destroy
    @message.destroy!

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  def set_application
    @application = Application.find_by(token: params[:application_token])
    unless @application
      render json: { error: 'Application not found' }, status: :not_found
    end
  end

  def set_chat
    @chat = @application.chats.find_by(num: params[:chat_num])
    unless @chat
      render json: { error: 'Chat not found' }, status: :not_found
    end
  end

  def set_message
    @msg = @chat.messages.find_by(msg_no: params[:msg_no])
    unless @msg
      render json: { error: 'Msg not found' }, status: :not_found
    end
  end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:content)
    end
end
