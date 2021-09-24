module Polycon
  module Models
    class Appointment
      def self.create_appointment(date, name, surname, phone, notes)
        date = date.gsub " ", "_"
        File.open("#{date}.paf", "w") {|file| file.write("#{name}\n#{surname}\n#{phone}\n#{notes}")}
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
    end
  end
end