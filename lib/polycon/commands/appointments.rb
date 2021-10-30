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
            if !Polycon::Models::Appointment.valid_date_for_appointment?(date)
              warn "Los horarios de los turnos son cada media hora"
              return 1
            else
              if Polycon::Models::Appointment.date_is_sunday?(date)
                warn "La fecha ingresada no puede ser domingo"
                return 1
              else
                if (Polycon::Models::Appointment.date_greater_than_today(date))
                  prof = Polycon::Models::Professional.find_professional(professional)
                  if prof.nil?
                    warn "El profesional ingresado no existe"
                    return 1
                  else
                    appointment = prof.find_appointment(date)
                    if !appointment.nil?
                      warn "Ya existe un turno para esa fecha, para dicho profesional"
                      return 1
                    else
                      Polycon::Models::Appointment.create_appointment(date, name, surname, phone, notes, prof)
                      warn "Turno creado exitosamente"
                    end
                  end
                else
                  warn "La fecha ingresada debe ser mayor a la fecha de hoy"
                end
              end
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
            prof = Polycon::Models::Professional.find_professional(professional)
            if prof.nil?
              warn "El profesional ingresado no existe"
              return 1
            else
              appointment = prof.find_appointment(date)
              if appointment.nil?
                warn "No existe un turno para esa fecha"
                return 1
              else
                puts "Nombre: #{appointment.name}"
                puts "Apellido: #{appointment.surname}"
                puts "Telefono: #{appointment.phone}"
                puts "Notas: #{appointment.notes}" unless appointment.notes.nil?
              end
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
              prof = Polycon::Models::Professional.find_professional(professional)
              if prof.nil?
                warn "El profesional ingresado no existe"
                return 1
              else
                appointment = prof.find_appointment(date)
                if appointment.nil?
                  warn "No existe un turno para esa fecha"
                  return 1
                else
                  appointment.cancel_appointment
                  warn "Turno cancelado exitosamente"
                end
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
          prof = Polycon::Models::Professional.find_professional(professional)
          if prof.nil?
            warn "El profesional ingresado no existe"
            return 1
          else
            prof.cancel_all_appointments
            warn "Se han cancelado todos los turnos del profesional posteriores a la fecha de hoy"
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
          if Polycon::Models::Appointment.valid_date?(date)
            prof = Polycon::Models::Professional.find_professional(professional)
            if prof.nil?
              warn "El profesional ingresado no existe"
              return 1
            else
              appointments = prof.appointments(date)
              if appointments.empty?
                warn "No hay turnos"
              else
                appointments.each do |appointment|
                  puts "Dia: #{appointment.get_only_date} Hora: #{appointment.get_only_hour}"
                end
              end
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
            if !Polycon::Models::Appointment.valid_date_for_appointment?(new_date)
              warn "Los horarios de los turnos son cada media hora"
              return 1
            else
              if Polycon::Models::Appointment.date_is_sunday?(new_date)
                warn "La fecha ingresada no puede ser domingo"
                return 1
              else
                if (Polycon::Models::Appointment.date_greater_than_today(old_date) && Polycon::Models::Appointment.date_greater_than_today(new_date))
                  prof = Polycon::Models::Professional.find_professional(professional)
                  if prof.nil?
                    warn "El profesional ingresado no existe"
                    return 1
                  else
                    appointment = prof.find_appointment(old_date)
                    if appointment.nil?
                      warn "No existe un turno para esa fecha, para dicho profesional"
                      return 1
                    else
                      if appointment.reschedule(new_date)
                        warn "El turno se ha modificado exitosamente"
                      else
                        warn "Existe un turno en esa fecha nueva para ese profesional"
                      end
                    end
                  end
                else
                  warn "La fecha ingresada debe ser mayor a la fecha de hoy"
                end
              end
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
            prof = Polycon::Models::Professional.find_professional(professional)
            if prof.nil?
              warn "El profesional ingresado no existe"
              return 1
            else
              appointment = prof.find_appointment(date)
              if appointment.nil?
                warn "No existe un turno para esa fecha"
                return 1
              else
                appointment.edit(options)
                appointment.save(date)
                warn "Turno modificado exitosamente"
              end
            end
          else
            warn "Debe ingresar una fecha y hora válida"
          end
        end
      end
    end
  end
end
