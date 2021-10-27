module Polycon
  module Utils
    def self.ensure_polycon_exists
      Dir.chdir(ENV["HOME"])
      if not File.exists?("./.polycon")
        Dir.mkdir(".polycon")
      end
      Dir.chdir(".polycon")
    end

    def self.access_professional_directory(professional)
      self.ensure_polycon_exists
      Dir.chdir("#{professional}")
    end

    def self.appointments(date, professional)
      i=0
      appointments = []
      self.access_professional_directory(professional)
      if(not date.nil?)
        Dir.foreach(".") do |appointment|
          next if appointment == '.' || appointment == '..'
          appointment = File.basename appointment, '.paf'
          dateAppointment = Date.strptime(appointment, '%Y-%m-%d')
          if (dateAppointment.to_s == date)
            appointments[i] = appointment
            i+=1
          end
        end
      else
        Dir.foreach(".") do |appointment|
          appointment = File.basename appointment, '.paf'
          appointments[i] = appointment
          i+=1
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

  end
end