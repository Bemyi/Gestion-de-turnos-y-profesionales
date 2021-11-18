class Appointment < ApplicationRecord
  belongs_to :professional

  validates :name, :surname, :phone, presence: true
  validate :date_greater_than_today, :date_is_sunday?, :valid_date_for_appointment?, :already_exists
  protected #para que solo se puedan utilizar aca los metodos

  def date_greater_than_today
    if self.date < DateTime.now
      errors.add :date, 'La fecha ingresada debe ser mayor a la fecha de hoy'
    end
  end

  def date_is_sunday?
    if self.date.sunday?
      errors.add :date, 'La fecha ingresada no puede ser domingo'
    end
  end

  def valid_date_for_appointment?
    if !(self.date.min == 0 || self.date.min == 30)
      errors.add :date, 'Los horarios de los turnos son cada media hora'
    end
  end

  def already_exists
    if self.professional.find_appointment(self)
      errors.add :date, 'Ya existe un turno para esa fecha, para dicho profesional'
    end
  end

  
end
