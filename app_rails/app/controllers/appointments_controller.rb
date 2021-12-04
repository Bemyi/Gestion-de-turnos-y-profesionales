class AppointmentsController < ApplicationController
  load_and_authorize_resource
  before_action :set_professional
  before_action :set_appointment, only: %i[ show edit update destroy ]

  # GET /appointments or /appointments.json
  def index
    @appointments = @professional.appointments.order(:date)

    if search_params[:dateS].present?
      @appointments = @appointments.search_by_date(search_params[:dateS])
    end

    @dateS = search_params[:dateS]
  end

  # GET /appointments/1 or /appointments/1.json
  def show
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new
  end

  # GET /appointments/1/edit
  def edit
  end

  # POST /appointments or /appointments.json
  def create
    @appointment = @professional.appointments.new(appointment_params)

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to [@professional, @appointment], notice: "Appointment was successfully created." }
        format.json { render :show, status: :created, location: @appointment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appointments/1 or /appointments/1.json
  def update
    respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to [@professional, @appointment], notice: "Appointment was successfully updated." }
        format.json { render :show, status: :ok, location: @appointment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    if @appointment.destroy
      message = "Appointment was successfully cancelled."
    else
      message = @appointment.errors.full_messages.to_sentence
    end
    redirect_to professional_appointments_path(@professional), notice: message
  end

  def cancel_all
    @professional.cancel_all
    respond_to do |format|
      format.html { redirect_to professional_appointments_path(@professional), notice: "Appointments were successfully cancelled." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = @professional.appointments.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def appointment_params
      params.require(:appointment).permit(:name, :surname, :phone, :notes, :date)
    end

    def set_professional
      @professional = Professional.find(params[:professional_id])
    end

    def search_params
      if params.key?(:search)
        params.require(:search).permit(:dateS)
      else
        {}
      end
    end
end
