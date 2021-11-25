class PresentationsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  def new
    @presentation = Presentation.new
  end

  def appointments
    @professionals = Professional.order(:name)
  end

  def export_appointments
    @presentation = Presentation.new(presentations_params)
    if @presentation.valid?
      unless presentations_params[:professional].blank?
        @professional = Professional.find(@presentation.professional)
      end
      if @presentation.type == "Dia"
        helpers.export_appointments_in_day(@presentation.date, @professional)
      else
        helpers.export_appointments_in_week(@presentation.date, @professional)
      end
      redirect_to :action => 'appointments', notice: "La grilla fue creada con éxito, puede encontrarla en el directorio actual: #{Dir.pwd}."
    end
  end

  private
  def presentations_params
    params.require(:form_data).permit(:professional, :date, :type)
  end
end