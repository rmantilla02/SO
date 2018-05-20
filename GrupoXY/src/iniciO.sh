LOGFILE=inicializador
source log.sh

GRUPO=$(pwd | sed "s-\(.*GrupoXY\).*-\1-")

# reporta si algo salió mal
function reportar() {
    echo -e "\e[1;31m$1\e[0m"
    echo -e "\e[1;31mPara reparar la instalación corra el script './instalador.sh -r'\e[0m"
}

while read linea; do
    if [[ -z $linea ]]; then continue; fi

    key=$(echo "$linea" | cut -d- -f1)
    ruta=$(echo "$linea" | cut -d- -f2)

    # SETEAR VARIABLES DE AMBIENTE
    case "$key" in
        ejecutables) export EJECUTABLES=$ruta;;
        maestros) export MAESTROS=$ruta;;
        arribos) export ARRIBOS=$ruta;;
        aceptados) export ACEPTADOS=$ruta;;
        rechazados) export RECHAZADOS=$ruta;;
        procesados) export PROCESADOS=$ruta;;
        reportes) export REPORTES=$ruta;;
        logs) export LOGS=$ruta;;
    esac

done < "$GRUPO/dirconf/configuracion.conf"

# VERIFICAR DIRECTORIOS
for directory in EJECUTABLES MAESTROS ARRIBOS ACEPTADOS RECHAZADOS PROCESADOS REPORTES LOGS; do
    if [ ! -v $directory ]; then
        echo "no esta $directory en archivo de configuracion"
    elif [ ! -d ${!directory} ]; then
        reportar "directorio de $directory no existe"
    fi
done

# VERIFICAR / CORREGIR PERMISOS
log  "se cambian los permisos en MAESTROS y EJECUTABLES"
echo "se cambian los permisos en MAESTROS y EJECUTABLES"
find "$MAESTROS" -type f -exec chmod u+r {} +
find "$EJECUTABLES" -type f -exec chmod u+x {} +

# ARRANCAR EL DEMONIO

$EJECUTABLES/detectO.sh &
export PID_DAEMON=$!
echo "Demonio iniciado con id de proceso $PID_DAEMON"
