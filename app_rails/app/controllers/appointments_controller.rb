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

    if @appointment.save
      redirect_to [@professional, @appointment], notice: "Appointment was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /appointments/1 or /appointments/1.json
  def update
    if @appointment.update(appointment_params)
      redirect_to [@professional, @appointment], notice: "Appointment was successfully updated." 
    else
      render :edit, status: :unprocessable_entity 
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
    redirect_to professional_appointments_path(@professional), notice: "Appointments were successfully cancelled." 
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
