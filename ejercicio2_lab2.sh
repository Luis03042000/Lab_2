#!/bin/bash
# Este script monitorea el estado de  un proceso, si no está en ejecución lo levanta

#Se verifica que se ingresaron dos parámetros
if [ $# -ne 2 ]; then
echo "Faltan argumentos"
exit 1
fi

nombre=$1
comando=$2

#Función de verificación
verificando() {
 if ! pgrep -x "$nombre" > /dev/null; then # estructura condicional que busca segun el nombre exacto y envía el resultado a /dev/null
echo "El proceso $nombre no se está ejecutando. Se inicia ejecución..."
$comando & # Para ejecutar en backgroud
  else
    echo "El proceso $nombre está en ejecución."
  fi
}


while true; do # Esto genera un bucle infinito para estar monitoreando el proceso cada 5 s llamando a la función
  verificando 
  sleep 5 
done
