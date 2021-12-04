class Professional < ApplicationRecord
  has_many :appointments, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  before_destroy :has_appointments?, prepend: true #prioriza este callback, lo ordena primero
  
  def to_s
    name
  end

  def cancel_all
    self.appointments.where("date > ?", DateTime.now).destroy_all
  end

  protected

  def has_appointments?
    if self.appointments.where("date > ?", DateTime.now).exists?
      errors.add :base, 'The professional has pending appointments'
    throw :abort #para frenar
    end
  end
end
