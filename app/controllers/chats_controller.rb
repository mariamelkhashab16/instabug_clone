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
    @application.with_lock do
      current_chat_count = @application.chats_count
      new_chat_num = current_chat_count + 1
      @chat = @application.chats.new(num: new_chat_num)
    
      if @chat.save
        @application.increment!(:chats_count)
        render json: @chat, status: :created
      else
        render json: @chat.errors, status: :unprocessable_entity
      end
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
