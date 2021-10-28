module Polycon
  module Commands
    module Presentation
      class AppointmentsInDay < Dry::CLI::Command
        desc 'Generates a grid with all the appointments of a day'

        argument :date, required: true, desc: 'An appointment date'
        option :professional, required: false, desc: 'Name of a professional'

        example [
          '"2021-09-16"      # Generate a grid with all the appointments for that day"',
          '"2021-09-16" --professional="Alma Estevez" # Generate a grid with the appointments of a professional on that day"'
        ]

        def call(date:, professional:nil)
          if !professional.nil?
            prof = Polycon::Models::Professional.find_professional(professional)
            if prof.nil?
              warn "El profesional ingresado no existe"
              return 1
            end
          end
          Polycon::Presentation.appointments_in_day(date, prof)
        end
      end

      class AppointmentsInWeek < Dry::CLI::Command
        desc 'Generates a grid with all the appointments of a week'

        argument :date, required: true, desc: 'An appointment date'
        option :professional, required: false, desc: 'Name of a professional'

        example [
          '"2021-09-16"      # Generate a grid with all the appointments for that week"',
          '"2021-09-16" --professional="Alma Estevez" # Generate a grid with the appointments of a professional on that week"'
        ]

        def call(date:, professional:nil)
          if !professional.nil?
            prof = Polycon::Models::Professional.find_professional(professional)
            if prof.nil?
              warn "El profesional ingresado no existe"
              return 1
            end
          end
          Polycon::Presentation.appointments_in_week(date, prof)
        end
      end
    end
  end
end
