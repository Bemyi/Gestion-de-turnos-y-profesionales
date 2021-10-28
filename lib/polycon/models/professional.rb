module Polycon
  module Models
    class Professional
      attr_accessor :name
      def initialize(name)
        @name = name
      end
      def self.ensure_professional_exists(name)
        Polycon::Utils.ensure_professional_exists(name)
      end

      def self.create_professional(name)
        professional = new(name)
        Polycon::Utils.create_directory_professional(name)
      end

      def appointments
        Polycon::Utils.appointments(name).map do |date|
          Polycon::Models::Appointment.from_file(name, date)
        end
      end

      def has_appointments?(name)
        !appointments.select do |appointment|
          appointment.date.to_s > Time.now.strftime("%Y-%m-%d")
        end.empty?
      end

      def self.find_professional(name)
        professional = new(name)
        return professional if professional.exists?
      end

      def exists?
        Utils.ensure_professional_exists(self.name)
      end

      def self.professional_names
        professionals = []
        Polycon::Utils.professional_names.map do |name|
          professionals << new(name)
        end
        professionals
      end

      def self.professional_delete(name)
        Polycon::Utils.professional_delete(name)
      end

      def self.professional_rename(old_name, new_name)
        File.rename(old_name, new_name)
      end
    end
  end
end