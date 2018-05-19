#!/bin/bash

if [ ! -v PID_DAEMON ]; then echo "demonio no esta corriendo"; exit; fi

echo "Matando demonio pid" $PID_DAEMON
kill $PID_DAEMON
