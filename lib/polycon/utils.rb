module Polycon
  module Utils
    def self.ensure_polycon_exists
      Dir.chdir(ENV["HOME"])
      if not File.exists?("./.polycon")
        Dir.mkdir(".polycon")
      end
      Dir.chdir(".polycon")
    end

    def self.root_path
      root_path = Dir.home + "/.polycon"
      FileUtils.mkdir_p root_path
      root_path
    end

    def self.access_professional_directory(professional)
      FileUtils.mkdir_p root_path + "#{professional.name}"
    end

    def self.appointments(professional, date=nil)
      appointments = []
      if(not date.nil?)
        Dir.foreach(root_path + "/#{professional.name}") do |appointment|
          next if appointment == '.' || appointment == '..'
          appointment = self.remove_paf(appointment)
          dateAppointment = Date.strptime(appointment, '%Y-%m-%d')
          if (dateAppointment.to_s == date.to_s)
            appointments << appointment
          end
        end
      else
        Dir.foreach(root_path + "/#{professional.name}") do |appointment|
          next if appointment == '.' || appointment == '..'
          appointment = self.remove_paf(appointment)
          appointments << appointment
        end
      end
      return appointments
    end

    def self.appointments_in_day(date, professional)
      appointments = []
      if (not professional.nil?)
        self.access_professional_directory(professional)
        Dir.foreach(".") do |appointment|
          next if appointment == '.' || appointment == '..'
          appointment_aux = self.remove_paf(appointment)
          if (Date.strptime(appointment_aux, '%Y-%m-%d') == date)
            appointments << Polycon::Models::Appointment.from_file(professional, (File.basename appointment, '.paf'))
          end   
        end
      else
        Dir.glob("**/*.paf") do |appointment|
          appointment_aux = self.remove_paf(appointment)
          if (Date.strptime(appointment_aux, '%Y-%m-%d') == date)
            self.access_professional_directory(appointment[..-22])
            appointments << Polycon::Models::Appointment.from_file(appointment[..-22], (File.basename appointment, '.paf'))
          end
        end
      end
      return appointments
    end

    def self.remove_paf(file)
      File.basename file, '.paf'
    end

    def self.save_template(template, date, title, appointments, horas, dates=nil)
      Polycon::Utils.ensure_polycon_exists
      File.open("Appointments_of_#{date}.html", "w+") {|file| file.write("#{template.result binding}")}
    end

    def self.ensure_professional_exists(professional)
      File.exists?root_path + "/#{professional.name}"
    end

    def self.save_professional(professional)
      FileUtils.mkdir_p root_path + "/#{professional.name}"
    end

    def self.professional_delete(professional)
      FileUtils.rm_rf root_path + "/#{professional.name}"
    end

    def self.professional_names
      professionals = []
      Dir.foreach(root_path) do |professional|
        next if professional == "." or professional == ".."         
        professionals << professional
      end
      professionals
    end

    def self.from_file(appointment, professional, date)
      File.open(root_path + "/#{professional.name}/#{date}.paf", 'r') do |line|
        appointment.professional = professional.name
        appointment.date = Date.strptime((date[..-7]), "%Y-%m-%d")
        appointment.hour = date[11..].gsub '-', ':'
        appointment.surname = line.readline.chomp
        appointment.name = line.readline.chomp
        appointment.phone = line.readline.chomp
        if (!line.eof?)
          appointment.notes = line.readline.chomp
        end
      end
    end

    def self.rename_professional(professional, new_name)
      File.rename(root_path + "/#{professional.name}", new_name)
    end
  end
end