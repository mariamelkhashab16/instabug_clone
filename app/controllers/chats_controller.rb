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
    # Enqueue a job to create the chat asynchronously
    CreateChatJob.perform_later(@application)
    render json: { chat: 'Chat creation queued' }, status: :accepted
  end
  
  

  private

  def set_application
    @application = Application.find_by(token: params[:application_token])
    unless @application
      render json: { error: 'Application not found' }, status: :not_found
    end
  end
end
