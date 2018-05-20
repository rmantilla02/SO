#!/bin/bash

LOGFILE=daemon
source log.sh


# function para mover los archivos
function moveFile() {
    local dir=${1}; shift
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
    moveFile $REJECTED_DIR ${1}
    # log archivo rechazado: $(basename $1)${2:+, $2}
    infoLog "rejectFile" "archivo rechazado $1"
    # echo "archivo rechazado: " $(basename $1)
}

function acceptFile() {
    moveFile $ACCEPTED_DIR ${1}
    # log archivo aceptado: $(basename $1)
    infoLog "acceptFile" "archivo aceptado $1"
    # echo "archivo aceptado: " $(basename $1)
}

function processFile() {
	
    local name=$(basename $1)

#   validamos que el archivo no esté vacío
    if ! [ -s $1 ]; then
        rejectFile $1 "archivo vacio"; return;
    fi

    # validacion de nombre
    if ! [[ $name =~ [^_]+-[^_]+-[^_]+-[^_]+\.txt ]]; then
        echo "nombre archivo invalido"
        infoLog "processFile" "nombre de archivo inválido"
        rejectFile $1; return;
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

    done < $MASTER_DIR/p-s.mae

    # si no existe en p-s.mae se rechaza
    if [ "$exist" = "false" ]; then
        infoLog "processFile" "el archivo no existe en P-S.mae"
        rejectFile $1; return;
    fi

    if [ "$year" -lt 2016 ]; then
        infoLog "processFile" "año inválido."
        rejectFile $1; return;
    fi

    # validacion de mes
    echo "mes: " $month
    if [ "$month" -lt 1 ] || [ "$month" -gt 12 ]; then
        infoLog "processFile" "mes inválido."
        rejectFile $1; return;
    fi

    acceptFile $1
}


for (( ciclo = 1; ; ciclo++ )); do
    # log "ciclo número: " $ciclo
    infoLog "processFile" "ciclo número: " $ciclo
    echo "ciclo número: " $ciclo
    if [ $(($ciclo%100)) -eq 0 ]; then truncate; fi

    sleep 7

    if [ -z "$(ls -A $ARRIVAL_DIR)" ]; then continue; fi
    for file in $ARRIVAL_DIR/*; do processFile $file; done
    
    if [ ! -z "$(ls -A $ACCEPTED_DIR)" ];
    	log "detecO" "se invoca al interpretO"
    	echo "invocando a interpretO"
    	then $BIN_DIR/interpretO.sh;
    fi
done