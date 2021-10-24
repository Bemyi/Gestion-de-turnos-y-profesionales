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
      Dir.chdir("./#{professional}")
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

    def self.appointments_in_day(date)
      i=0
      appointments = []
      if(not professional.nil?)
        self.access_professional_directory(professional)
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
        hash = {}
        Dir.glob("**/*.paf") do |appointment|
          #appointment = File.basename appointment, '.paf'
          self.access_professional_directory(appointment[..-22])
          Polycon::Models::Appointment.from_file()
          appointments[i] = appointment
          i+=1
        end
      end
      return appointments
    end
  end
end