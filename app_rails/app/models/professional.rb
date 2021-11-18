class Professional < ApplicationRecord
  has_many :appointments, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  before_destroy :has_appointments?, prepend: true #prioriza este callback, lo ordena primero
  
  def to_s
    name
  end

  def find_appointment(appointment)
    puts self.appointments.where("date = ? AND id != ?", appointment.date, appointment.id).exists?
    if self.appointments.where("date = ? AND id != ?", appointment.date, appointment.id).exists?
      puts "entro true"
      true
    else
      puts "entro false"
      false
    end
  end

  protected

  def has_appointments?
    if self.appointments.where("date > ?", DateTime.now).exists?
      errors.add :base, 'El profesional ingresado tiene turnos pendientes'
    throw :abort #para frenar
    end
  end
end
