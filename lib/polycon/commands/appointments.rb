module Polycon
  module Commands
    module Appointments
      class Create < Dry::CLI::Command
        desc 'Create an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: true, desc: "Patient's name"
        option :surname, required: true, desc: "Patient's surname"
        option :phone, required: true, desc: "Patient's phone number"
        option :notes, required: false, desc: "Additional notes for appointment"

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name=Carlos --surname=Carlosi --phone=2213334567'
        ]

        def call(date:, professional:, name:, surname:, phone:, notes: nil)
          if Polycon::Models::Appointment.valid_date_time?(date)
            if (Polycon::Models::Appointment.date_greater_than_today(date))
              Polycon::Utils.ensure_polycon_exists
              if Polycon::Models::Professional.ensure_professional_exists(professional)
                Polycon::Utils.access_professional_directory(professional)
                date = Polycon::Models::Appointment.date_format(date)
                if not Polycon::Models::Appointment.ensure_appointment_exists(date)
                  Polycon::Models::Appointment.create_appointment(date, name, surname, phone, notes)
                  warn "Turno creado exitosamente"
                else
                  warn "Ya existe una fecha para ese dia y hora"
                end
              else
                warn "El profesional ingresado no existe"
              end
            else
              warn "La fecha ingresada debe ser mayor a la fecha de hoy"
            end
          else
            warn "Debe ingresar una fecha y hora válida"
          end
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show details for an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Shows information for the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          if Polycon::Models::Appointment.valid_date_time?(date)
            Polycon::Utils.ensure_polycon_exists
            if Polycon::Models::Professional.ensure_professional_exists(professional)
              Polycon::Utils::access_professional_directory(professional)
              date = Polycon::Models::Appointment.date_format(date)
              if (Polycon::Models::Appointment.ensure_appointment_exists(date))
                appointment = Polycon::Models::Appointment.from_file(date)
                puts appointment.name
                puts appointment.surname
                puts appointment.phone
                puts appointment.notes unless appointment.notes.nil?
              else
                warn "No existe turno con esa fecha y hora"
              end
            else
              warn "No existe el profesional"
            end
          else
            warn "Debe ingresar una fecha y hora válida"
          end
        end
      end

      class Cancel < Dry::CLI::Command
        desc 'Cancel an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Cancels the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          if Polycon::Models::Appointment.valid_date_time?(date)
            if (Polycon::Models::Appointment.date_greater_than_today(date))
              Polycon::Utils.ensure_polycon_exists
              if Polycon::Models::Professional.ensure_professional_exists(professional)
                Polycon::Utils::access_professional_directory(professional)
                date = Polycon::Models::Appointment.date_format(date)
                if (Polycon::Models::Appointment.ensure_appointment_exists(date))
                  Polycon::Models::Appointment.cancel_appointment(date)
                  warn "Turno cancelado exitosamente"
                else
                  warn "No existe turno con esa fecha y hora"
                end
              else
                warn "No existe el profesional"
              end
            else
              warn "La fecha ingresada debe ser mayor a la fecha de hoy"
            end
          else
            warn "Debe ingresar una fecha y hora válida"
          end
        end
      end

      class CancelAll < Dry::CLI::Command
        desc 'Cancel all appointments for a professional'

        argument :professional, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez" # Cancels all appointments for professional Alma Estevez',
        ]

        def call(professional:)
          Polycon::Utils.ensure_polycon_exists
          if Polycon::Models::Professional.ensure_professional_exists(professional)
            Polycon::Models::Appointment.cancel_all_appointments(professional)
            warn "Se han cancelado todos los turnos del profesional"
          else
            warn "No existe el profesional"
          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List appointments for a professional, optionally filtered by a date'

        argument :professional, required: true, desc: 'Full name of the professional'
        option :date, required: false, desc: 'Date to filter appointments by (should be the day)'

        example [
          '"Alma Estevez" # Lists all appointments for Alma Estevez',
          '"Alma Estevez" --date="2021-09-16" # Lists appointments for Alma Estevez on the specified date'
        ]

        def call(professional:, date:nil)
          if date.nil? || Polycon::Models::Appointment.valid_date?(date)
            Polycon::Utils.ensure_polycon_exists
            if Polycon::Models::Professional.ensure_professional_exists(professional)
              appointments = Polycon::Models::Appointment.appointments(date, professional)
              if appointments.empty?
                warn "No hay turnos"
              else
                appointments.each do |appointment|
                  puts appointment
                end
              end
            else
              warn "No existe el profesional"
            end
          else
            warn "Debe ingresar una fecha válida"
          end
        end
      end

      class Reschedule < Dry::CLI::Command
        desc 'Reschedule an appointment'

        argument :old_date, required: true, desc: 'Current date of the appointment'
        argument :new_date, required: true, desc: 'New date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" "2021-09-16 14:00" --professional="Alma Estevez" # Reschedules appointment on the first date for professional Alma Estevez to be now on the second date provided'
        ]

        def call(old_date:, new_date:, professional:)
          if Polycon::Models::Appointment.valid_date_time?(old_date) && Polycon::Models::Appointment.valid_date_time?(new_date)
            if (Polycon::Models::Appointment.date_greater_than_today(old_date) && Polycon::Models::Appointment.date_greater_than_today(new_date))
              Polycon::Utils.ensure_polycon_exists
              if Polycon::Models::Professional.ensure_professional_exists(professional)
                Polycon::Utils::access_professional_directory(professional)
                old_date = Polycon::Models::Appointment.date_format(old_date)
                new_date = Polycon::Models::Appointment.date_format(new_date)
                if Polycon::Models::Appointment.ensure_appointment_exists(old_date)
                  Polycon::Models::Appointment.reschedule_appointment(old_date, new_date)
                  warn "El turno se ha modificado exitosamente"
                else
                  warn "No existe turno con esa fecha y hora"
                end
              else
                warn "No existe el profesional"
              end
            else
              warn "La fecha ingresada debe ser mayor a la fecha de hoy"
            end
          else
            warn "Debe ingresar una fecha y hora válida"
          end
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit information for an appointments'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: false, desc: "Patient's name"
        option :surname, required: false, desc: "Patient's surname"
        option :phone, required: false, desc: "Patient's phone number"
        option :notes, required: false, desc: "Additional notes for appointment"

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" # Only changes the patient\'s name for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" --surname="New surname" # Changes the patient\'s name and surname for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --notes="Some notes for the appointment" # Only changes the notes for the specified appointment. The rest of the information remains unchanged.',
        ]

        def call(date:, professional:, **options)
          if Polycon::Models::Appointment.valid_date_time?(date)
            Polycon::Utils.ensure_polycon_exists
            if Polycon::Models::Professional.ensure_professional_exists(professional)
              Polycon::Utils::access_professional_directory(professional)
              date = Polycon::Models::Appointment.date_format(date)
              if Polycon::Models::Appointment.ensure_appointment_exists(date)
                appointment = Polycon::Models::Appointment.from_file(date)
                appointment.edit(options)
                appointment.save(date)
                warn "Turno modificado exitosamente"
              else
                warn "No existe turno con esa fecha y hora"
              end
            else
              warn "No existe el profesional"
            end
          else
            warn "Debe ingresar una fecha y hora válida"
          end
        end
      end
    end
  end
end
