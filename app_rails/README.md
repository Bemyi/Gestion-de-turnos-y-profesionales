### Entrega 1:

### Models

Cree un module models, el cual contiene los models appointment y professionals. De esta forma el command realiza llamados a los methods de cada modelo y se abstrae de tener que realizar alguna función que en realidad debería realizar el model en cuestión.

### Utils

Cree un module Utils dentro de polycon, el cual lo utilizo para verificar la existencia de polycon (si no existe, lo crea) y para posicionarme en el directorio de un professional.

### Validación y creación de .polycon

Yo planteé que cada vez que se realice una operación, tanto de appointment como professional, se verifique que existe y si no existe se crea.

### Validación del professional

Cuando realizo una operación sobre un professional, verifico que existe y si no existe, se le muestra al usuario un warn informandole que el professional no existe.

### Creación de un professional

A la hora de crear un professional chequeo que no exista y si no existe, es creado.

### Eliminación de un professional

Si no tiene appointments pendientes, se puede eliminar el professional.

### Listar professionals

Si no hay professionals creados, se imprimirá un cartel avisando que no hay.

### Renombrar un professional

Para crearlo, se realiza un chequeo de si no existe el nuevo nombre como professional.

### Validación de una fecha

Se verifica que la fecha enviada por parámetro sea un Date o DateTime correcto, depende el caso.

### Validación del appointment

Cuando realizo una operación sobre un appointment, verifico que existe y si no existe, se le muestra al usuario un warn informandole que el appointment no existe.

### Creación de un appointment

Se valida que solo se puedan crear appointments con fecha mayor a la fecha y hora actual. También que no exista un appointment para esa fecha y hora ingresada.

### Mostrar un appointment

Para mostrarlo, utilizo un método from_file(date), el cual devuelve un objeto appointment y con ese puedo imprimir lo que contiene el appointment requerido. A notes se le pregunta si es nil porque es opcional tener notes en un appointment.

### Cancelar un appointment de un professional

Solo se pueden cancelar appointments que tengan fecha mayor a la fecha y hora actual

### Cancelar todos los appointments de un professional

Solo cancela los appointments que tengan fecha mayor a la fecha y hora actual, de esta forma se conserva un historial de los appointments

### Listar appointments para un professional

Se verifica que sea pasado una fecha como parámetro, en dicho caso se imprime los appointments que tiene el professional ese dia, caso contrario, se imprimen todas las appointments que tiene ese professional. Si no hay ningún appointment se informa que no hay turnos.

### Reprogramar un appointment

Solo se pueden reprogramar appointments con fecha mayor a la fecha y hora actual. No se puede reprogramar para una fecha y hora donde ya existe un appointment para ese professional.

### Editar un appointment

Para editarlo, utilizo un método from_file(date), devuelve un objeto appointment, el cual tiene un método para editarlo y otro para guardarlo en el archivo. Se puede editar información de turnos que ya fueron atendidos.

### Entrega 2:

### Creación de nuevo comando Presentations

Se creó un nuevo comando para poder pedir la exportación de una grilla semanal o de un día en específico (dós métodos separados). En ambos métodos se valida la fecha y el profesional, luego se realiza el llamado a un método de Presentation (para semana o día, según corresponda).

### Creación del directorio Templates

En este se guardan templates .html.erb, los cuales son utilizados en Presentation para poder generar la grilla con la librería ERB.

### Exportar appointments para un dia

Utilizando la librería ERB, leemos de un template para guardar el esqueleto de la grilla, luego se envía el template con los datos necesarios para escribir en él al método Utils.save_template, el cual lo que hace es escribir el template en un nuevo archivo .html, generado en donde se encuentre parado el usuario que ejecuta el comando.

### Métodos de soporte en Presentation:

### first_day_of_week

Es usado a la hora de crear la grilla semanal, para obtener el día lunes, según la fecha que venga por parámetro. Si viene un día mayor que lunes, vuelve al lunes de esa semana, si viene el día domingo, me devuelve el lunes que le sigue al mismo.

### appointments_day_template

Con todos los appointments(puede ser de un professional o de todos), filtra y se queda con los que coincidan para un día en específico.

### appointments_week_template

Con todos los appointments(puede ser de un professional o de todos), filtra y se queda con los que coincidan para un rango de 6 días

### appointments_template

Si el parámetro professional es nil, obtiene todos los appointments de todos los professionals, sino, obtiene todos los de un professional específico.

### dates_template

Devuelve un arreglo de 6 fechas, las 5 siguientes de la que fue pasada por parámetro.

### horas_template

Devuelve un arreglo de strings de horas, de las 10 a las 20:30 (es un rango de horarios que pensé yo para el polyconsultorio).

### Correcciones entrega 1:

### Utils

Todo lo referido a acceso a disco que estaban en los modelos fueron movidos a Utils.

### Professional y Appointment

Se corrigió que professional y appointment fuera más objetoso y la mayoría de los métodos que eran de clases, fueron pasados a instancia (ej: métodos que crean, modifican, etc.). De esta forma, por ejemplo, a la hora de validar que un professional exista, se crea la instancia del mismo, si este es nil significa que el professional no existe, si se devuelve una instancia professional, es porque existe.

### Otras desiciones de diseño:

Se asume que el usuario ingresa los turnos en bloque de media hora y que están en el rango de 10 a 21, siendo el último turno el de las 20:30hs

### Entrega 3:

Todo lo de la entrega 2 se pasó a rails, ahora se guarda toda la información en una base de datos.

### Users:

Se creó un modelo users, para poder realizar la autenticación de usuarios con roles. Para la autenticación se utilizó la gema devise y para los roles cancancan.
Los roles se guardan como int en la bd:
0 --> consulta
1 --> asistencia
2 --> administracion
A la administración de los usuarios, solo puede acceder un usuario el rol de administración. El mismo puede ver, editar, crear y eliminar a los demás usuarios, sobre él mismo solo puede ver y editar datos.

### Corrección de la entrega anterior:

Ya no se filtran los appointments en la vista, se envía un hash desde la clase Presentation con los appointments organizados por fecha y hora.

### Descarga de grillas:

Ahora no se guarda la grilla en un directorio, sino que se le envía al usuario como un descargable, la lógica de la exportación de grilla queda en una clase en el directorio /app/presentation.
Si se envía el campo professional en blanco, se asume que quiere la grilla de todos los professionals.
Cualquier rol puede descargar grillas.
