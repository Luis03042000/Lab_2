#!/bin/bash

#Script que monitoreará un proceso en cuanto al CPU y memoria

if [ -z "$1" ]; then # Se verifica si el argumento está vacío
  echo "Argumento inválido o inexistente"
  exit 1
fi

# Se designan algunas variables importantes
ejecutable=$1 
datos="consumo.log" 
grafico="grafico.gnuplot"

> $datos # Se realiza para limpiar 

echo "Ejecutando el proceso '$ejecutable'..."
$ejecutable & # Se ejecuta el proceso en background

pid=$! # Este es un script en bash que captura el PID del último comando ejecutado 

if [ -z "$pid" ]; then # Verificando que el proceso se haya ejecutado correctamente y exista un pid
  echo "Error: No se pudo obtener el PID del proceso '$ejecutable'."
  exit 1
fi

echo "T(s) CPU(%) Mem(KB)" >> $datos

tiempo_inicial=$(date +%s)

# Esta estrucutura condicional lo que hace es verificar si el proceso con el pid indicado está en ejecución, esta es la condición y cualquier mensaje de error lo redirige a /dev/null 
while kill -0 $pid 2>/dev/null; do
tiempo_actual=$(date +%s)
tiempo_transcurrido=$((tiempo_actual - tiempo_inicial))

  # Obtención de datos del cpu y memoria del pid indicado, además se limpian
cpu=$(ps -p $pid -o %cpu=)
 memoria=$(ps -p $pid -o rss=)

# Se realiza una comprobación de si los datos se obtuvieron con éxito o si alguna variable quedó vacía
  if [ -z "$cpu" ] || [ -z "$memoria" ]; then
    echo "Error: No se pudieron obtener los datos de CPU/memoria."
    break
  fi

  echo "$tiempo_transcurrido $cpu $memoria" >> $datos

# Se monitorearán los datos cada 5 segundos
  sleep 5
done

echo "El proceso ha terminado."

# Código para generar los gráficos de los datos obtenidos 
cat <<EOL > $grafico
set terminal png size 1000,800
set output 'grafico.png'
set multiplot layout 2,1 title 'Monitoreo de CPU y Memoria'

# Gráfico de uso de CPU
set title 'Uso de CPU (%)'
set xlabel 'Tiempo (s)'
set ylabel 'Uso de CPU (%)'
set grid
plot '$datos' using 1:2 with lines title 'Uso de CPU (%)'

# Gráfico de uso de Memoria
set title 'Uso de Memoria (KB)'
set xlabel 'Tiempo (s)'
set ylabel 'Uso de Memoria (KB)'
set grid
plot '$datos' using 1:3 with lines title 'Uso de Memoria (KB)'

unset multiplot
EOL

gnuplot $grafico

echo "Gráfico generado en 'grafico.png'."

# Comandos para imprimir los resultados
cat consumo.log
xdg-open grafico.png
