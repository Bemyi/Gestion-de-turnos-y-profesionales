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

    def self.remove_paf(file)
      File.basename file, '.paf'
    end

    def self.save_template(template, date, title, appointments, horas, dates=nil)
      File.open("#{Dir.pwd}/appointments_of_#{date}.html", "w+") {|file| file.write("#{template.result binding}")}
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
        appointment.professional = professional
        appointment.date = DateTime.strptime(date, "%Y-%m-%d_%H-%M")
        appointment.surname = line.readline.chomp
        appointment.name = line.readline.chomp
        appointment.phone = line.readline.chomp
        if (!line.eof?)
          appointment.notes = line.readline.chomp
        end
      end
      appointment
    end

    def self.rename_professional(professional, new_name)
      File.rename(root_path + "/#{professional.name}", new_name)
    end

    def self.ensure_appointment_exists(appointment)
      File.exists?root_path + "/#{appointment.professional.name}/#{date_format(appointment.date)}.paf"
    end

    def self.date_format(date)
      date.strftime("%Y-%m-%d_%H-%M")
    end

    def self.save_appointment(appointment)
      File.open(root_path + "/#{appointment.professional.name}/#{date_format(appointment.date)}.paf", "w") {|file| file.write("#{appointment.surname}\n#{appointment.name}\n#{appointment.phone}\n#{appointment.notes}")}
    end

    def self.cancel_appointment(appointment)
      File.delete(root_path + "/#{appointment.professional.name}/#{date_format(appointment.date)}.paf")
    end

    def self.cancel_all_appointments(professional)
      hoy = Time.now.strftime("%Y-%m-%d_%H-%M")
      Dir.foreach(root_path + "/#{professional.name}") do |appointment|
        next if appointment == "." or appointment == ".."
        if appointment > hoy
          File.delete(root_path + "/#{professional.name}/#{appointment}")
        end
      end
    end
    
    def self.reschedule_appointment(appointment, new_date)
      File.rename(root_path + "/#{appointment.professional.name}/#{date_format(appointment.date)}.paf", root_path + "/#{appointment.professional.name}/#{date_format(new_date)}.paf")
    end
  end
end