module Polycon
  module Models
    class Professional
      def self.ensure_professional_exists(name)
        File.exists?(name)
      end

      def self.create_directory_professional(name)
        Dir.mkdir(name)
      end

      def self.have_appointments?(name)
        encontroTurno = false
        Dir.foreach("./#{name}") do |turno|
          if (turno > Time.now.strftime("%Y-%m-%d_%H-%M"))
            encontroTurno = true
            return encontroTurno
          end
        end
      end

      def self.professional_names
        i=0
        professionals = []
        Dir.foreach(".") do |professional|
          next if professional == "." or professional == ".."         
          professionals[i] = professional
          i+=1
        end
        return professionals
      end

      def self.professional_delete(name)
        FileUtils.rm_rf(name)
      end

      def self.professional_rename(old_name, new_name)
        File.rename(old_name, new_name)
      end
    end
  end
end