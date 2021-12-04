class ExportPresentation

  def export_appointments_in_day(date, professional)
    date = Date.strptime(date, "%Y-%m-%d")
    title = "appointments_of_day_#{date}"
    template = ERB.new(File.read(Rails.root.join("templates/appointments_in_day.html.erb")))
    save_template(template, date, title, appointments_day_template(date, professional), horas_template())
  end

  def export_appointments_in_week(date, professional)
    date = Date.strptime(date, "%Y-%m-%d")
    date = first_day_of_week(date)
    title = "appointments_of_week_#{date}"
    template = ERB.new(File.read(Rails.root.join("templates/appointments_in_week.html.erb")))
    save_template(template, date, title, appointments_week_template(date, professional), self.horas_template(), self.dates_template(date))
  end

  def first_day_of_week(date)
    if date.wday > 1
      date = date - (date.wday-1)
    else
      if date.wday == 0
        date = date + 1
      end
    end
    date
  end

  def appointments_day_template(date, professional)
    appointments = appointments_template(professional)
    appointments.select { |appointment| appointment.date.to_date == date }
  end

  def appointments_template(professional)
    appointments = []
    if professional.nil?
      Professional.all.map do |prof|
        appointments += prof.appointments
      end
    else
      appointments = professional.appointments
    end
    appointments
  end

  def appointments_week_template(date, professional)
    appointments = appointments_template(professional)
    appointments = appointments.select { |appo| (date..date+6).cover? appo.date.to_date }
    appointmentsTemplate = {}
    self.dates_template(date).each do |date|
      appointmentsTemplate[date] = {}
      self.horas_template.each do |hour|
        appointmentsTemplate[date][hour] = []
        appointments.each do |appointment|
          if date == appointment.date.to_date && hour == appointment.get_only_hour
            appointmentsTemplate[date][hour] << appointment
          end
        end
      end
    end
    self.dates_template(date).each do |date|
      self.horas_template.each do |hour|
        puts "otra hora"
        puts appointmentsTemplate[date][hour]
      end
    end
    puts "HOLAAA"
    appointmentsTemplate
  end

  def dates_template(date)
    dates = []
    (1...7).each do
      dates << date
      date = date.next_day
    end
    dates
  end

  def horas_template()
    horas = []
    for i in 10..20 do
      horas << "#{i}:00"
      horas << "#{i}:30"
    end
    horas
  end

  def save_template(template, date, title, appointmentsTemplate, horas, dates=nil)
    File.open(Rails.root.join("tmp/appointments_of_#{date}.html"), "w+") {|file| file.write("#{template.result binding}")}
  end
end