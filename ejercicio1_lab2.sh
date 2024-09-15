
#!/bin/bash
# Se realizará el programa de resolución del lab. dos

#Primera parte de scripting y procesos

PID=$1 # El argumento ingresado al ejecutar el script se guarda en esa variable 

# Se revisará si el proceso enviado como argumento existe 
# Con ps se muestra info de los procesos y la opción -p $PID lo que hace es mostrar los datos de procesos con solo ese PID. Con el > se asegura enviar los resultados o errores a /dev/null para que no se presente en la terminal y con el exit 1 es para cuando llegu eeste código de salida termine el script indicando que hubo un problema.


if ! ps -p $PID > /dev/null 2>&1; then
  echo "El proceso con PID $PID no existe."
  exit 1
fi

nombre=$(ps -p $PID -o comm=)
proceso_padre_ID=$(ps -p $PID -o ppid=)
usuario_propietario=$(ps -p $PID -o user=)
uso_CPU=$(ps -p $PID -o %cpu=)
consumo_mem=$(ps -p $PID -o rss=)
estado=$(ps -p $PID -o state=)
path_ejecutable=$(readlink -f /proc/$PID/exe)


echo "Nombre del proceso: $nombre"
echo "ID del proceso (PID): $PID"
echo "ID del proceso padre (PPID): $proceso_padre_ID"
echo "Usuario propietario: $usuario_propietario"
echo "Uso de CPU: $uso_CPU%"
echo "Consumo de memoria: $consumo_mem KB"
echo "Estado: $estado"
echo "Ruta ejecutable: $path_ejecutable"



