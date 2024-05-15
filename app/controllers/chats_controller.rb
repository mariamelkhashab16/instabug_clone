class ChatsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_application

  # GET /applications/:token/chats
  def index
    @chats = @application.chats
    render json: @chats
  end

  def show
    @chat = @application.chats.find_by(num: params[:num])

    respond_to do |format|
      # format.html # Render HTML view (if needed)
      format.json { render json: @chat }
    end
  end

  def create
    CreateChatJob.perform_later(@application)
    render json: { message: 'Chat creation queued' }, status: :accepted
  end
  
  

  private

  def set_application
    @application = Application.find_by(token: params[:application_token])
    unless @application
      render json: { error: 'Application not found' }, status: :not_found
    end
  end
end
