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
          Polycon::Utils.ensure_polycon_exists
          if Polycon::Models::Professional.ensure_professional_exists(name)
            warn "El profesional ya existe"
          else
            Polycon::Models::Professional.create_directory_professional(name)
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
          Polycon::Utils.ensure_polycon_exists
            if Polycon::Models::Professional.ensure_professional_exists(name)
              if not (Polycon::Models::Professional.have_appointments?(name))
                Polycon::Models::Professional.professional_delete(name)
                warn "Profesional eliminado exitosamente"
              else
                warn "El profesional ingresado tiene turnos pendientes"
              end
            else
              warn "El profesional ingresado no existe"
            end
        end
      end

      class List < Dry::CLI::Command
        desc 'List professionals'

        example [
          "          # Lists every professional's name"
        ]

        def call(*)
          Polycon::Utils.ensure_polycon_exists
          if (Polycon::Models::Professional.professional_names).empty?
            warn "No hay profesionales"
          else
            (Polycon::Models::Professional.professional_names).each do |professional|
              puts professional
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
            if not Polycon::Models::Professional.ensure_professional_exists(new_name)
              if Polycon::Models::Professional.ensure_professional_exists(old_name)
                Polycon::Models::Professional.professional_rename(old_name, new_name)
                warn "El nombre se ha modificado exitosamente"
              else
                warn "El profesional ingresado no existe"
              end
            else
              warn "El nombre del profesional nuevo ya existe"
            end
        end
      end
    end
  end
end
