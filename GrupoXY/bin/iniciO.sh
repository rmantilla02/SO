LOGFILE=iniciO
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
    infoLog "checkIniciO" "se setea variables de ambiente."
    case "$key" in
        bin) export BIN_DIR=$ruta;;
        master) export MASTER_DIR=$ruta;;
        arrival) export ARRIVAL_DIR=$ruta;;
        accepted) export ACCEPTED_DIR=$ruta;;
        rejected) export REJECTED_DIR=$ruta;;
        processed) export PROCESSED_DIR=$ruta;;
        reports) export REPORTS_DIR=$ruta;;
        logs) export LOGS_DIR=$ruta;;
    esac

done < "$GRUPO/dirconf/configuracion.conf"

# VERIFICAR DIRECTORIOS
for directory in BIN_DIR MASTER_DIR ARRIVAL_DIR ACCEPTED_DIR REJECTED_DIR PROCESSED_DIR REPORTS_DIR LOGS_DIR; do
    if [ ! -v $directory ]; then
        echo "no esta $directory en archivo de configuracion"
    elif [ ! -d ${!directory} ]; then
        errorLog "checkDirectory" "no existe el directorio."
        reportar "directorio de $directory no existe"
    fi
done

# VERIFICAR / CORREGIR PERMISOS
infoLog "checkGrants" "se cambian los permisos en MAESTROS y EJECUTABLES."
echo "se cambian los permisos en MAESTROS y EJECUTABLES"
find "$MASTER_DIR" -type f -exec chmod u+r {} +
find "$BIN_DIR" -type f -exec chmod u+x {} +

# ARRANCAR EL DEMONIO

$BIN_DIR/detectO.sh &
export PID_DAEMON=$!
infoLog "invokeDaemon" "se invoca al demonio."
echo "Demonio iniciado con id de proceso $PID_DAEMON"
