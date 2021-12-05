class ProfessionalsController < ApplicationController
  load_and_authorize_resource
  before_action :set_professional, only: %i[ show edit update destroy ]

  # GET /professionals or /professionals.json
  def index
    @professionals = Professional.order(:name)
  end

  # GET /professionals/1 or /professionals/1.json
  def show
  end

  # GET /professionals/new
  def new
    @professional = Professional.new
  end

  # GET /professionals/1/edit
  def edit
  end

  # POST /professionals or /professionals.json
  def create
    @professional = Professional.new(professional_params)

    if @professional.save
      redirect_to @professional, notice: "Professional was successfully created."
    else
      render :new, status: :unprocessable_entity 
    end
  end

  # PATCH/PUT /professionals/1 or /professionals/1.json
  def update
      if @professional.update(professional_params)
        redirect_to @professional, notice: "Professional was successfully updated."
      else
        render :edit, status: :unprocessable_entity 
      end
  end

  # DELETE /professionals/1 or /professionals/1.json
  def destroy
    if @professional.destroy
      message = "Professional was successfully destroyed."
    else
      message = @professional.errors.full_messages.to_sentence
    end
    redirect_to professionals_url, notice: message
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_professional
      @professional = Professional.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def professional_params
      params.require(:professional).permit(:name)
    end
end
