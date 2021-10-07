require 'date'
module Polycon
  module Models
    class Appointment
      attr_accessor :name, :surname, :phone, :notes
      def self.create_appointment(date, name, surname, phone, notes)
        date = date.gsub " ", "_"
        File.open("#{date}.paf", "w") {|file| file.write("#{surname}\n#{name}\n#{phone}\n#{notes}")}
      end

      def self.date_format(date)
        date = "#{date.gsub " ", "_"}.paf"
      end

      def self.ensure_appointment_exists(date)
        File.file?(date)
      end

      def self.reschedule_appointment(old_date, new_date)
        File.rename(old_date, new_date)
      end

      def self.show_appointment(date)
        File.readlines(date).each do |line|
          puts line
        end
      end

      def self.cancel_appointment(date)
        File.delete(date)
      end

      def self.cancel_all_appointments
        FileUtils.rm_rf(Dir.glob('./*'))
      end

      def self.appointments(date, professional)
        i=0
        appointments = []
        if(not date.nil?)
          Dir.children(professional).each do |appointment|
            appointment = File.basename appointment, '.paf'
            dateAppointment = Date.strptime(appointment, '%Y-%m-%d')
            if (dateAppointment.to_s == date)
              appointments[i] = appointment
              i+=1
            end
          end
        else
          Dir.children(professional).each do |appointment|
            appointment = File.basename appointment, '.paf'
            appointments[i] = appointment
            i+=1
          end
        end
        return appointments
      end

      def self.from_file(date)
        date = date.gsub ' ', '_'
        appointment = new
        File.open("#{date}.paf", 'r') do |line|
          appointment.surname = line.readline.chomp
          appointment.name = line.readline.chomp
          appointment.phone = line.readline.chomp
          if (not line.eof?)
            appointment.notes = line.readline.chomp
          end
        end
        appointment
      end

      def save(date)
        date = date.gsub ' ', '_'
        File.open("#{date}.paf", 'w') do |line|
          line << "#{surname}\n"
          line << "#{name}\n"
          line << "#{phone}\n"
          line << notes
        end
      end

      def edit(options)
        options.each do |key, value|
          self.send(:"#{key}=", value)
        end
      end

      def self.valid_date_time?(date)
        begin
          DateTime.strptime(date, "%Y-%m-%d %H-%M")
          true
        rescue ArgumentError
        false
        end
      end

      def self.valid_date?(date)
        begin
          Date.strptime(date, "%Y-%m-%d")
          true
        rescue ArgumentError
        false
        end
      end
    end
  end
end