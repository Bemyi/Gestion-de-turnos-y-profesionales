json.extract! appointment, :id, :professional_id, :name, :surname, :phone, :notes, :date, :created_at, :updated_at
json.url appointment_url(appointment, format: :json)
