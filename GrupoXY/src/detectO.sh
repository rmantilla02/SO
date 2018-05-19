#!/bin/bash

LOGFILE=daemon
source log.sh


# function para mover los archivos
function moveFile() {
    local dir=${1:? llamado sin argumentos}; shift
    if ! [ -d $dir ]; then
        echo "argumento 1 $1 no era un directorio" >&2
    fi

    for file in $@; do
        local bn=$(basename $file)
        local dest="$dir/$bn"

        if [ -f $dest ]; then
            # se crea subdirectorio dup si ya existe el archivo en rechazados
            mkdir --parents $dir/dup
            local dup=$(ls $dir/dup | grep "^[0-9][0-9]$bn" | tail --lines=1)
            local nro=${dup::2}
            nro=$(printf %02d $(($nro + 1)))
            dest="$dir/dup/$nro$bn"
        fi

        mv $file $dest
    done
}

# Rechaza un archivo y registra el evento en el log.
#
# El segundo argumento es un mensaje opcional que se agrega al log.
function rejectFile() {
    moveFile $RECHAZADOS ${1:?"rechazar llamado sin argumentos"}
    log archivo rechazado: $(basename $1)${2:+, $2}
    echo "archivo rechazado: " $(basename $1)
}

function acceptFile() {
    moveFile $ACEPTADOS ${1?"aceptar llamado sin argumentos"}
    log archivo aceptado: $(basename $1)
    echo "archivo aceptado: " $(basename $1)
}

function processFile() {
	
    local name=$(basename $1)

    echo "processFile: " $name

#   validamos que el archivo no esté vacío
    if ! [ -s $1 ]; then
        rejectFile $1 "archivo vacio"; return;
    fi

    # validacion de nombre
    if ! [[ $name =~ [^_]+-[^_]+-[^_]+-[^_]+\.txt ]]; then
        echo "nombre archivo invalido"
        rejectFile $1 "nombre de archivo inválido"; return;
    fi

    local noext=${name%.*}
    IFS='-' read -r -a array <<< "$noext"

    country=${array[0]}
    system=${array[1]}
    year=${array[2]}
    month=${array[3]}

    # echo "country: " $country
    # echo "system:  " $system

    # se valida que country y system existan en p-s.mae
    exist=false
    while read -r line; do
        # echo "line: " $line
        IFS='-' read -r -a array <<< "$line"
        country_aux=${array[0]}
        system_aux=${array[2]}

        # echo "country_aux: " $country_aux
        # echo "system_aux: " $system_aux

        if [ $country = $country_aux ] && [ $system = $system_aux ]; then
            exist=true
            break
        fi

    done < $MAESTROS/p-s.mae

    # si no existe en p-s.mae se rechaza
    if [ "$exist" = "false" ]; then
        echo "no existe el archivo en maestro"
        rejectFile $1 "novedad rechazada"; return;
    fi

    if [ "$year" -lt 2016 ]; then
        echo "año menor a 2016: " $year
        rejectFile $1 "novedad rechazada"; return;
    fi

    # validacion de mes
    echo "mes: " $month
    if [ "$month" -lt 1 ] || [ "$month" -gt 12 ]; then
        echo "mes invalido"
        rejectFile $1 "novedad rechazada"; return;
    fi

    acceptFile $1
}


for (( ciclo = 1; ; ciclo++ )); do
    log "ciclo número: " $ciclo
    echo "ciclo número: " $ciclo
    if [ $(($ciclo%100)) -eq 0 ]; then truncate; fi

    sleep 7

    if [ -z "$(ls -A $ARRIBOS)" ]; then continue; fi
    for file in $ARRIBOS/*; do processFile $file; done
    
    if [ ! -z "$(ls -A $ACEPTADOS)" ];
    	log "invocando a interpretO"
    	echo "invocando a interpretO"
    	then $EJECUTABLES/interpretO.sh; fi
done