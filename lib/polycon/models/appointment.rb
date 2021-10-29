require 'date'
module Polycon
  module Models
    class Appointment
      attr_accessor :name, :surname, :phone, :notes, :date, :professional

      def initialize(date=nil, professional=nil, name=nil, surname=nil, phone=nil, notes=nil)
        @date = date
        @professional = professional
        @name = name
        @surname = surname
        @phone = phone
        @notes = notes
      end

      def self.create_appointment(date, name, surname, phone, notes, professional)
        date = DateTime.strptime(date, "%Y-%m-%d %H:%M")
        appointment = new(date, professional, name, surname, phone, notes)
        Polycon::Utils.save_appointment(appointment)
      end

      def reschedule(new_date)
        if !self.professional.find_appointment(new_date).nil?
          return false
        else
          new_date = DateTime.strptime(new_date, "%Y-%m-%d %H:%M")
          Polycon::Utils.reschedule_appointment(self, new_date)
          self.date = new_date
          return true
        end
      end

      def cancel_appointment
        Polycon::Utils.cancel_appointment(self)
      end

      def self.from_file(professional, date)
        date = (date.gsub ' ', '_').gsub ':', '-'
        appointment = new
        Polycon::Utils.from_file(appointment, professional, date)
        appointment
      end

      def save(date)
        Polycon::Utils.save_appointment(self)
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
          date = Date.strptime(date, "%Y-%m-%d")
          true
        rescue ArgumentError
        false
        end
      end

      def self.date_greater_than_today(old_date)
        hoy = Time.now.strftime("%Y-%m-%d %H:%M")
        old_date > hoy
      end

      def exists?
        Utils.ensure_appointment_exists(self)
      end

      def get_only_date
        date.to_date
      end

      def get_only_hour
        date.strftime("%H:%M")
      end

      def self.valid_date_for_appointment?(date)
        date = DateTime.strptime(date, "%Y-%m-%d %H:%M")
        if date.minute == 0 || date.minute == 30
          true
        end
      end
      
      def self.date_is_sunday?(date)
        date = DateTime.strptime(date, "%Y-%m-%d %H:%M")
        if date.wday == 0
          true
        end
      end
    end
  end
end