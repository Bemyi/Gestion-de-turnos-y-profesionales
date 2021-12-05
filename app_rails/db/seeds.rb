# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#Users
User.create(email: 'admin@gmail.com', password: '123456', role: 2)
User.create(email: 'asistencia@gmail.com', password: '123456', role: 1)
User.create(email: 'consulta@gmail.com', password: '123456', role: 0)
#Professionals
Professional.create(name: 'Carlos')
Professional.create(name: 'Pepe')
Professional.create(name: 'Jose')
#Appointments
Appointment.create(professional_id: 1, name: 'Maria', surname: 'Freccero', phone: '2345645342', date: DateTime.strptime("12/20/2021 16:00", "%m/%d/%Y %H:%M"))
Appointment.create(professional_id: 1, name: 'Mario', surname: 'Freccero', phone: '2345645343', date: DateTime.strptime("12/20/2021 15:00", "%m/%d/%Y %H:%M"))
Appointment.create(professional_id: 2, name: 'Luis', surname: 'Garcia', phone: '2345645344', date: DateTime.strptime("12/20/2021 15:00", "%m/%d/%Y %H:%M"))
Appointment.create(professional_id: 2, name: 'Josefina', surname: 'Garcia', phone: '2345645345', date: DateTime.strptime("12/22/2021 15:00", "%m/%d/%Y %H:%M"))
Appointment.create(professional_id: 3, name: 'Jorge', surname: 'Starnari', phone: '2345645346', date: DateTime.strptime("12/23/2021 17:00", "%m/%d/%Y %H:%M"))
Appointment.create(professional_id: 3, name: 'Martin', surname: 'Pereyra', phone: '2345645348', date: DateTime.strptime("12/23/2021 19:00", "%m/%d/%Y %H:%M"))