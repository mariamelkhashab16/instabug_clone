class ApplicationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_application, only: %i[ show edit update destroy ]

  # GET /applications or /applications.json
  def index
    @applications = Application.all
    @applications = @applications.map do |application|
      {
        name: application.name,
        token: application.token,
        chats_count: application.chats_count,
        created_at: application.created_at,
        updated_at: application.updated_at
      }
    end
    render json: @applications
  end

  # GET /applications/1 or /applications/1.json
  def show
    @application = Application.find_by(token: params[:token]) 
    response = {name: @application.name,
              token: @application.token,
              chats_count: @application.chats_count,
              created_at: @application.created_at,
              updated_at: @application.updated_at
          }   
    render json: response
  end
  
  # POST /applications or /applications.json
  def create
    @application = Application.new(name: application_params[:name], token: generate_token)

    respond_to do |format|
    if @application.save
      format.json { render json: { token: @application.token }, status: :created, location: @application }
    else
      format.json { render json: @application.errors, status: :unprocessable_entity }
    end
  end
  end

  # PATCH/PUT /applications/1 or /applications/1.json
  def update
    respond_to do |format|
      ActiveRecord::Base.transaction do
        if @application.with_lock(true) { @application.update(application_params) }
        updated_application = @application.reload # gets the latest changes
        response =   {name: updated_application.name,
                token: updated_application.token,
                chats_count: updated_application.chats_count,
                created_at: updated_application.created_at,
                updated_at: updated_application.updated_at
        }
          format.json { render json: response, status: :ok }
        else
          format.json { render json: @application.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  
  

  # DELETE /applications/1 or /applications/1.json
  def destroy
    @application.destroy!
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find_by(token: params[:token])
    end

    # Only allow a list of trusted parameters through.
    def application_params
      params.require(:application).permit(:name)
    end

    private
    def generate_token
      SecureRandom.hex(16)
    end
end
