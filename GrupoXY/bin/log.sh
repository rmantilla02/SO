# Este script es una biblioteca. Para invocarla use 'source log.sh'

# Guarde el nombre del log en la variable LOGFILE.
if [ ! -v LOGFILE ]; then LOGFILE=log; else LOGFILE+=".log"; fi

# Añade un registro al log de la forma "[yyyy-mm-dd hh:mm:ss] <args>" donde args son los argumentos de la funcion.
function log() {
    if [ ! -v LOGS_DIR ] || [ ! -d $LOGS_DIR ]; then return; fi
    echo [$(date "+%F %T")-$(whoami)-"$1"-"$2"] "$3" >> $LOGS_DIR/$LOGFILE
}

infoLog() {
	log $1 "INFO" $2
}

warnLog() {
	log $1 "WARN" $2
}

errorLog() {
	log $1 "ERROR" $2
}

function truncate() {
    # n es el primer argumento de truncate, o 500 por default.
    local n=${1:-500}
    tmp=$(mktemp)
    tail $LOGS_DIR/$LOGFILE -n $n > tmp
    mv tmp $LOGS_DIR/$LOGFILE
}
