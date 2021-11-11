class Appointment < ApplicationRecord
  belongs_to :professional

  validates :name, :surname, :phone, presence: true

  protected #para que solo se puedan utilizar aca los metodos

  def validacion_custom
    # if expires_at && expires_at < Date.today --> errors.add :expires_at, 'heey la cagaste'
  end

end
