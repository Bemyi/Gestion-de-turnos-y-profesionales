require 'erb'
require 'date'
module Polycon
  module Presentation

    def self.export_appointments_in_day(date, professional)
      date = Date.strptime(date, "%Y-%m-%d")
      title = "appointments_of_day_#{date}"
      template = ERB.new(File.read("lib/polycon/templates/appointments_in_day.html.erb"))
      Polycon::Utils.save_template(template, date, title, appointments_day_template(date, professional), horas_template())
    end

    def self.export_appointments_in_week(date, professional)
      date = Date.strptime(date, "%Y-%m-%d")
      date = first_day_of_week(date)
      title = "appointments_of_week_#{date}"
      template = ERB.new(File.read("lib/polycon/templates/appointments_in_week.html.erb"))
      Polycon::Utils.save_template(template, date, title, appointments_week_template(date, professional), self.horas_template(), self.dates_template(date))
    end

    def self.first_day_of_week(date)
      if date.wday > 1
        date = date - (date.wday-1)
      else
        if date.wday == 0
          date = date + 1
        end
      end
      date
    end

    def self.appointments_day_template(date, professional)
      appointments = appointments_template(professional)
      appointments.select { |appointment| appointment.get_only_date == date }
    end

    def self.appointments_template(professional)
      appointments = []
      if professional.nil?
        Polycon::Models::Professional.professional_names.map do |prof|
          appointments += prof.appointments()
        end
      else
        appointments += professional.appointments()
      end
      appointments
    end

    def self.appointments_week_template(date, professional)
      appointments = appointments_template(professional)
      appointments.select { |appo| (date..date+6).cover? appo.get_only_date }
    end

    def self.dates_template(date)
      dates = []
      (1...7).each do
        dates << date
        date = date.next_day
      end
      dates
    end

    def self.horas_template()
      horas = []
      for i in 10..20 do
        horas << "#{i}:00"
        horas << "#{i}:30"
      end
      horas
    end
  end
end