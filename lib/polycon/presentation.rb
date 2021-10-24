require 'erb'
module Polycon
  module Presentation
    def self.appointments_in_day(date, professional)
      title = 'appointments'
      if (professional.nil?)
        appointments = Polycon::Models::Appointment.appointments_in_day(date)
      else
        appointments = Polycon::Models::Appointment.appointments_in_day(date, professional)
      end
      template = ERB.new <<~END, nil, '-'
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <title><%= title %></title>
          <meta charset="UTF-8">
        </head>
        <body>
          <table>
            <tr>
            <th>dia/hora</th>
            <%- appointments.each do |appointment| -%>
              <th><%= appointment.hour %></th>
            <%- end -%>
            </tr>
            <tr>
            <td><%= date %></td>
            <%- appointments.each do |appointment| -%>
              <td><%= appointment.name %></td>
            <%- end -%>
            </tr>
          </table>
        </body>
      </html>
      END
      Polycon::Utils.ensure_polycon_exists        
      File.open("Appointments_of_.html", "w+") {|file| file.write("#{template.result binding}")}
    end
  end
end