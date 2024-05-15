class ApplicationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_application, only: %i[ show edit update destroy ]

  # GET /applications or /applications.json
  def index
    @applications = Application.all
  end

  # GET /applications/1 or /applications/1.json
  def show
    @application = Application.find_by(token: params[:token])
    
    respond_to do |format|
      # format.html # Render HTML view (if needed)
      format.json { render json: @application }
    end
  end
  

  # GET /applications/new
  def new
    @application = Application.new
  end

  # GET /applications/1/edit
  def edit
  end

  # POST /applications or /applications.json
  def create
    @application = Application.new(name: application_params[:name], token: generate_token)

    respond_to do |format|
      if @application.save
        # format.html { redirect_to application_url(@application), notice: "Application was successfully created." }
        format.json { render json: { token: @application.token }, status: :created, location: @application }
      else
        # format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /applications/1 or /applications/1.json
  def update
    respond_to do |format|
      ActiveRecord::Base.transaction do
        if @application.with_lock(true) { @application.update(application_params) }
          format.json { render :show, status: :ok, location: @application }
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
      # format.html { redirect_to applications_url, notice: "Application was successfully destroyed." }
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
