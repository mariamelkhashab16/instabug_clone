class ChatsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_application

  # GET /applications/:token/chats
  def index
    @chats = @application.chats
    @chats = @chats.map do |chat|
      {
        chat_num: chat.num,
        count: chat.msgs_count,
        application_token: chat.application.token,
        created_at: chat.created_at,
        updated_at: chat.updated_at
      }
    end
    render json: @chats
  end

  def show
    @chat = @application.chats.find_by(num: params[:num])
    respond_to do |format|
      format.json { render json: @chat }
    end
  end

  def create
    new_chat_num = CreateChatJob.perform_now(@application)  # Perform the job synchronously to retrieve the new chat number
    if new_chat_num.present?
      render json: { message: "chat created successfully",chat_number: new_chat_num }, status: :created
    else
      render json: { error: 'Failed to create chat' }, status: :unprocessable_entity
    end
  end
  
  

  private

  def set_application
    @application = Application.find_by(token: params[:application_token])
    unless @application
      render json: { error: 'Application not found' }, status: :not_found
    end
  end
end
