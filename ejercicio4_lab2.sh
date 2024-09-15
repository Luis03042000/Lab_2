#!/bin/bash

# Directorio a monitorear
directorio="/home/luis/Descargas"

datos="/home/luis/monitor_log.txt"

# Monitoreando con inotifywait y dando el formato
inotifywait -m -r -e create -e modify -e delete "$directorio" --format '%T %w %f %e' --timefmt '%Y-%m-%d %H:%M:%S' | while read Fecha Hora directorio archivo  Evento
do

echo "$Fecha $Hora - $Evento en $directorio$archivo" >> "$datos"
done

