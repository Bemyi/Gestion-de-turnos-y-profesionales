class PresentationsController < ApplicationController
  load_and_authorize_resource

  def new
    @presentation = Presentation.new
  end

  def new_export
    @presentation = Presentation.new
  end

  def export_appointments
    @presentation = Presentation.new(presentations_params)
    if @presentation.valid?
      unless presentations_params[:professional].blank?
        @professional = Professional.find(@presentation.professional)
      end
      if @presentation.type == "Dia"
        helpers.export_appointments_in_day(@presentation.date, @professional)
        date = @presentation.date
      else
        helpers.export_appointments_in_week(@presentation.date, @professional)
        date = @presentation.date.to_date.at_beginning_of_week
      end
      send_file Rails.root.join("tmp/appointments_of_#{date}.html")
    else
      render :new_export, status: :unprocessable_entity
    end
  end

  private
  def presentations_params
    params.require(:form_data).permit(:professional, :date, :type)
  end
end