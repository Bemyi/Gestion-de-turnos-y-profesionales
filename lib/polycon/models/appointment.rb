require 'date'
module Polycon
  module Models
    class Appointment
      attr_accessor :name, :surname, :phone, :notes, :date, :hour, :professional
      def self.create_appointment(date, name, surname, phone, notes)
        date = (date.gsub " ", "_").gsub ":", "-"
        File.open("#{date}.paf", "w") {|file| file.write("#{surname}\n#{name}\n#{phone}\n#{notes}")}
      end

      def self.date_format(date)
        date = "#{(date.gsub " ", "_").gsub ":", "-"}"
      end

      def self.ensure_appointment_exists(date)
        File.file?("#{date}.paf")
      end

      def self.reschedule_appointment(old_date, new_date)
        File.rename("#{old_date}.paf", "#{new_date}.paf")
      end

      def self.show_appointment(date)

        File.readlines(date).each do |line|
          puts line
        end
      end

      def self.cancel_appointment(date)
        File.delete("#{date}.paf")
      end

      def self.cancel_all_appointments(professional)
        hoy = Time.now.strftime("%Y-%m-%d_%H-%M")
        Dir.children(professional).each do |appointment|
          if appointment > hoy
            File.delete("./#{professional}/#{appointment}")
          end
        end
      end

      def self.appointments(date, professional)
        puts date
        puts professional
        appointments = []
        Polycon::Utils.appointments(professional, date).map do |entry|
          puts entry
          appointments << self.from_file(professional, entry)
        end
        appointments
      end

      def self.appointments_in_day(date, professional)
        Polycon::Utils.appointments_in_day(date, professional)
      end

      def self.from_file(professional, date)
        date = (date.gsub ' ', '_').gsub ':', '-'
        appointment = new
        Polycon::Utils.from_file(appointment, professional, date)
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
          DateTime.strptime(date, "%Y-%m-%d %H:%M")
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

      def self.date_greater_than_today(old_date)
        hoy = Time.now.strftime("%Y-%m-%d %H:%M")
        old_date > hoy
      end
    end
  end
end