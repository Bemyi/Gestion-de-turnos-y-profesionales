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
      exportPresentation = ExportPresentation.new()
      unless presentations_params[:professional].blank?
        @professional = Professional.find(@presentation.professional)
      end
      if @presentation.type == "Dia"
        exportPresentation.export_appointments_in_day(@presentation.date, @professional)
        date = @presentation.date
      else
        exportPresentation.export_appointments_in_week(@presentation.date, @professional)
        date = @presentation.date.to_date.at_beginning_of_week
      end
      begin
        File.open(Rails.root.join("tmp/appointments_of_#{date}.html"), 'r') do |f|
          send_data f.read, :filename => "appointments_of_#{date}.html"
        end
      ensure 
        Rails.root.join("tmp/appointments_of_#{date}.html").unlink
      end
    else
      render :new_export, status: :unprocessable_entity
    end
  end

  private
  def presentations_params
    params.require(:form_data).permit(:professional, :date, :type)
  end
end