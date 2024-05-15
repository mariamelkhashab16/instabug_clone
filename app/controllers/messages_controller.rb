class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_application
  before_action :set_chat

  # GET /messages or /messages.json
  def index
    @msgs =@chat.messages
    render json: @msgs
  end

  # GET /messages/1 or /messages/1.json
  def show
    @message = @chat.messages.find_by(msg_no:params['msg_no'])
    respond_to do |format|
      # format.html # Render HTML view (if needed)
      format.json { render json: @message }
    end
  end


  # POST /messages or /messages.json
  def create
    # Extract message content from params
    message_content = message_params['content']

    # Enqueue a job to create the message asynchronously
    CreateChatMessageJob.perform_later(@chat, message_content)

    render json: { message: 'Chat message creation queued' }, status: :accepted
  end
  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        # format.html { redirect_to message_url(@message), notice: "Message was successfully updated." }
        format.json { render :show, status: :ok, location: @message }
      else
        # format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def search 
    filter = JSON.parse(request.body.read)
    search_by_content = filter['content']
    # @messages = @chat.messages.where("content LIKE ?", "%#{search_by_content}%")
    @messages = @chat.messages.search({
        query: {
          match: {
            "content": search_by_content # Assuming 'content' is the attribute containing the message content
          }
        }
      }).records
      render json: @messages
  end
  # DELETE /messages/1 or /messages/1.json
  def destroy
    @message.destroy!

    respond_to do |format|
      # format.html { redirect_to messages_url, notice: "Message was successfully destroyed." }
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
