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
        Polycon::Utils.save_professional(professional)
      end

      def appointments
        Polycon::Utils.appointments(self).map do |date|
          Polycon::Models::Appointment.from_file(self, date)
        end
      end

      def has_appointments?
        !appointments.select do |appointment|
          appointment.date.to_s > Time.now.strftime("%Y-%m-%d")
        end.empty?
      end

      def self.find_professional(name)
        professional = new(name)
        return professional if professional.exists?
      end

      def exists?
        Utils.ensure_professional_exists(self)
      end

      def self.professional_names
        professionals = []
        Polycon::Utils.professional_names.map do |name|
          professionals << new(name)
        end
        professionals
      end

      def delete()
        if !has_appointments?
          Polycon::Utils.professional_delete(self)
          true
        else
          false
        end
      end

      def rename(new_name)
        Polycon::Utils.rename_professional(self, new_name)
        self.name = new_name
      end
    end
  end
end