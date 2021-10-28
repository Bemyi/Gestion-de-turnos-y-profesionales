module Polycon
  module Commands
    module Professionals
      class Create < Dry::CLI::Command
        desc 'Create a professional'

        argument :name, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez"      # Creates a new professional named "Alma Estevez"',
          '"Ernesto Fernandez" # Creates a new professional named "Ernesto Fernandez"'
        ]

        def call(name:, **)
          professional = Polycon::Models::Professional.find_professional(name)
          if !professional.nil?
            warn "El profesional ya existe"
            return 1
          else
            Polycon::Models::Professional.create_professional(name)
            warn "Se ha creado el profesional exitosamente"
          end
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a professional (only if they have no appointments)'

        argument :name, required: true, desc: 'Name of the professional'

        example [
          '"Alma Estevez"      # Deletes a new professional named "Alma Estevez" if they have no appointments',
          '"Ernesto Fernandez" # Deletes a new professional named "Ernesto Fernandez" if they have no appointments'
        ]

        def call(name: nil)
          professional = Polycon::Models::Professional.find_professional(name)
          if professional.nil?
            warn "El profesional ingresado no existe"
            return 1
          else
              if professional.delete()
                warn "Profesional eliminado exitosamente"
              else
                warn "El profesional ingresado tiene turnos pendientes"
              end
          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List professionals'

        example [
          "          # Lists every professional's name"
        ]

        def call(*)
          if (Polycon::Models::Professional.professional_names).empty?
            warn "No hay profesionales"
          else
            (Polycon::Models::Professional.professional_names).each do |professional|
              puts professional.name
            end
          end
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a professional'

        argument :old_name, required: true, desc: 'Current name of the professional'
        argument :new_name, required: true, desc: 'New name for the professional'

        example [
          '"Alna Esevez" "Alma Estevez" # Renames the professional "Alna Esevez" to "Alma Estevez"',
        ]

        def call(old_name:, new_name:, **)
          Polycon::Utils.ensure_polycon_exists
          new_professional = Polycon::Models::Professional.find_professional(new_name)
          if !new_professional.nil?
            warn "El nombre del profesional nuevo ya existe"
            return 1
          else
            old_professional = Polycon::Models::Professional.find_professional(old_name)
            if old_professional.nil?
              warn "El profesional ingresado no existe"
              return 1
            else
              old_professional.rename(new_name)
              warn "El nombre se ha modificado exitosamente"
            end
          end
        end
      end
    end
  end
end
