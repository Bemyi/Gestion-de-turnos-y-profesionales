### Models

Cree un module models, el cual contiene los models appointment y professionals. De esta forma el command realiza llamados a los methods de cada modelo y se abstrae de tener que realizar alguna función que en realidad debería realizar el model en cuestión.

### Utils

Cree un module Utils dentro de polycon, el cual lo utilizo para verificar la existencia de polycon (si no existe, lo crea) y para posicionarme en el directorio de un professional.

### Validación y creación de .polycon

Yo planteé que cada vez que se realice una operación, tanto de appointment como professional, se verifique que existe y si no existe se crea.

### Validación del professional

Cuando realizo una operación sobre un professional, verifico que existe y si no existe, se le muestra al usuario un warn informandole que el professional no existe.

### Creación de un appointment

Planteé que cuando se crea un appointment para un professional el cual no existe, se cree el directorio con el respectivo appointment dentro.
