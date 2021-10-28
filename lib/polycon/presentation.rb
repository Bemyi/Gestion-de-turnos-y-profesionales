require 'erb'
require 'date'
module Polycon
  module Presentation

    def self.appointments_in_day(date, professional)
      date = Date.strptime(date, "%Y-%m-%d")
      title = "appointments_of_day_#{date}"
      #appointments = Polycon::Models::Appointment.appointments_in_day(date, professional)
      appointments = []
      if professional.nil?
        Polycon::Models::Professional.professional_names.map do |prof|
          appointments += prof.appointments()
        end
      else
        appointments += professional.appointments()
      end
      appointments.select! do |appointment|
        appointment.date.to_s > Time.now.strftime("%Y-%m-%d")
      end

      horas = self.horas_template()

      template = ERB.new <<~END, nil, '-'
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
          <title><%= title %></title>
          <meta charset="UTF-8">
        </head>
        <body>
          <table class="table table-bordered table-dark">
            <thead>
              <tr>
              <th scope="col">hora/dia</th>
                <th scope="col"><%= date %></th>
              </tr>
            </thead>
            <tbody>
            <%- horas.each do |hora| -%>
              <tr>
                <th scope="row"><%= hora %></th>
                <td>
                <%- appointments.each do |appo| -%>
                  <% if appo.hour == hora %>
                    <%= appo.name %> (<%= appo.professional %>)
                    <br>
                  <% end %>
                <%- end -%>
                <td>
              </tr>
            <%- end -%>
          </table>
        </body>
      </html>
      END
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

      template = ERB.new <<~END, nil, '-'
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
          <title><%= title %></title>
          <meta charset="UTF-8">
        </head>
        <body>
          <table class="table table-bordered table-dark">
            <thead>
              <tr>
              <th scope="col">hora/dia</th>
              <%- dates.each do |date| -%>
                <th scope="col"><%= date %></th>
              <%- end -%>
              </tr>
            </thead>
            <tbody>
            <%- horas.each do |hora| -%>
              
              <tr>
                <th scope="row"><%= hora %></th>
                <%- dates.each do |date| -%>
                  <td>
                    <%- appointments.each do |appo| -%>
                      <% if appo.hour == hora && appo.date == date %>
                        Profesional: <%= appo.professional %> - Paciente: <%= appo.name %> 
                        <br>
                      <% end %>
                    <%- end -%>
                  </td>
                <%- end -%>
              </tr>
            
            <%- end -%>
          </table>
        </body>
      </html>
      END
      Polycon::Utils.save_template(template, date, title, appointments, horas, dates)
    end

    def self.appointments_week_template(date, professional)
      appointments = []
      if professional.nil?
        for i in 1..7 do
          Polycon::Models::Professional.professional_names.map do |prof|
            appointments += prof.appointments()
          end
          date = date.next_day
        end
      else
        for i in 1..7 do
          appointments += prof.appointments()
          date = date.next_day
        end
      end
      appointments.select do |appointment|
        appointment.date.to_s > Time.now.strftime("%Y-%m-%d")
      end
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