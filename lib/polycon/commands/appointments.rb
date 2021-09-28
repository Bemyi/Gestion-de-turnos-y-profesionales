require 'polycon/utils.rb'
require 'polycon/models/professional.rb'
require 'polycon/models/appointment.rb'
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
          #warn "TODO: Implementar creación de un turno con fecha '#{date}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          Polycon::Utils.ensure_polycon_exists
          if not Polycon::Models::Professional.ensure_professional_exists(professional)
            Polycon::Models::Professional.create_directory_professional(professional)
          end
          Dir.chdir("./#{professional}")
          Polycon::Models::Appointment.create_appointment(date, name, surname, phone, notes)
          warn "Turno creado exitosamente"
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
          #warn "TODO: Implementar detalles de un turno con fecha '#{date}' y profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          Polycon::Utils.ensure_polycon_exists
          if Polycon::Models::Professional.ensure_professional_exists(professional)
            Dir.chdir("./#{professional}")
            date = Polycon::Models::Appointment.date_format(date)
            if (Polycon::Models::Appointment.ensure_appointment_exists(date))
              Polycon::Models::Appointment.show_appointment(date)
            else
              warn "No existe turno con esa fecha y hora"
            end
          else
            warn "No existe el profesional"
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
          #warn "TODO: Implementar borrado de un turno con fecha '#{date}' y profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          Polycon::Utils.ensure_polycon_exists
          if Polycon::Models::Professional.ensure_professional_exists(professional)
            Dir.chdir("./#{professional}")
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
        end
      end

      class CancelAll < Dry::CLI::Command
        desc 'Cancel all appointments for a professional'

        argument :professional, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez" # Cancels all appointments for professional Alma Estevez',
        ]

        def call(professional:)
          warn "TODO: Implementar borrado de todos los turnos de la o el profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
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

        def call(professional:)
          warn "TODO: Implementar listado de turnos de la o el profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
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
          #warn "TODO: Implementar cambio de fecha de turno con fecha '#{old_date}' para que pase a ser '#{new_date}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          Polycon::Utils.ensure_polycon_exists
          if Polycon::Models::Professional.ensure_professional_exists(professional)
            Dir.chdir("./#{professional}")
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
          #warn "TODO: Implementar modificación de un turno de la o el profesional '#{professional}' con fecha '#{date}', para cambiarle la siguiente información: #{options}.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          if File.exists?("#{ENV["HOME"]}/polycon")
            Dir.chdir("#{ENV["HOME"]}/polycon/#{professional}")
            date = date.gsub " ", "_"
            #options.each_value{|option| puts option}
            options.each do |key, value|
              linea = 1
              archivo = File.open("#{date}.paf").write
              archivo.each_line do line
                if (linea == 1)
                  puts "hola"
                end
                linea += 1
              end
            end
            #File.open("#{date}.paf", "r+") {|file| file.write("hola")}
          else
            warn "No existe el directorio polycon"
          end
        end
      end
    end
  end
end
