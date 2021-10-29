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
