module AppointmentsHelper
  def is_an_old_appointment?(appointment)
    if appointment.date < DateTime.now
      true
    end
  end
end
