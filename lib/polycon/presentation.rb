require 'erb'
require 'date'
module Polycon
  module Presentation

    def self.appointments_in_day(date, professional)
      date = Date.strptime(date, "%Y-%m-%d")
      title = "appointments_of_day_#{date}"
      appointments = []
      if professional.nil?
        Polycon::Models::Professional.professional_names.map do |prof|
          appointments += prof.appointments()
        end
      else
        appointments += professional.appointments()
      end
      appointments.select! do |appointment|
        appointment.date.to_s > Time.now.strftime("%Y-%m-%d") && appointment.date == date
      end
      horas = self.horas_template()

      template = ERB.new(File.read("lib/polycon/templates/appointments_in_day.html.erb"))
      Polycon::Utils.save_template(template, date, title, appointments, horas)
    end

    def self.appointments_in_week(date, professional)
      date = Date.strptime(date, "%Y-%m-%d")
      if (date.wday != 0)
        date = date - date.wday
      end
      dateTitle = date
      title = "appointments_of_week_#{dateTitle}"
      appointments = self.appointments_week_template(date, professional)
      horas = self.horas_template()
      dates = self.dates_template(date)

      template = ERB.new(File.read("lib/polycon/templates/appointments_in_week.html.erb"))
      Polycon::Utils.save_template(template, date, title, appointments, horas, dates)
    end

    def self.appointments_week_template(date, professional)
      appointmentsAux = []
      appointments = []
      if professional.nil?
        for i in 1..7 do
          Polycon::Models::Professional.professional_names.map do |prof|
            appointmentsAux += prof.appointments()
          end
          appointments += appointmentsAux.select! do |appointment|
            appointment.date.to_s > Time.now.strftime("%Y-%m-%d") && appointment.date == date
          end
          date = date.next_day
        end
      else
        for i in 1..7 do
          appointmentsAux += professional.appointments()
          appointments += appointmentsAux.select! do |appointment|
            appointment.date.to_s > Time.now.strftime("%Y-%m-%d") && appointment.date == date
          end
          date = date.next_day
        end
      end
      appointments
    end

    def self.dates_template(date)
      dates = []
      for i in 1..7 do
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