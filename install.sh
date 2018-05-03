#!/bin/bash
# Installation command for CONTROL system.

controlName () {
	echo "   __________  _   ____________  ____  __ "
	echo "  / ____/ __ \/ | / /_  __/ __ \/ __ \/ / "
	echo " / /   / / / /  |/ / / / / /_/ / / / / /  "
	echo "/ /___/ /_/ / /|  / / / / _, _/ /_/ / /___"
	echo "\____/\____/_/ |_/ /_/ /_/ |_|\____/_____/"
	echo "                                          "
	echo "Copyright 2018 © Grupo 06                      "
}

inputExecutables() {
	echo -n "Type the executables files directory, followed by [ENTER] ($GRUPO/bin): "
	read EXE_FILES_DIR
	
	if [ "$EXE_FILES_DIR" == "" ]; then
		EXE_FILES_DIR=$GRUPO/bin
	else
		EXE_FILES_DIR=$GRUPO/$EXE_FILES_DIR
	fi
}

updateExecutables() {
	echo -n "Actual executables files directory is $EXE_FILES_DIR, would you like to change it [Y/N]? "

	while true; do
		read UPDATE_OPTION
		UPDATE_OPTION=${UPDATE_OPTION^^}
		
		if [[ "YES" == *"$UPDATE_OPTION"* ]]; then
			inputExecutables
			break
		elif [[ "NO" == *"$UPDATE_OPTION"* ]]; then
			break
		else
			echo -n "Wrong option. Retype [Y/N]: "
		fi
	done
}

inputMaster() {
	echo -n "Type the master files and system tables directory, followed by [ENTER] ($GRUPO/master): "
	read MASTER_FILES_DIR

	if [ "$MASTER_FILES_DIR" == "" ]; then
		MASTER_FILES_DIR=$GRUPO/master
	else
		MASTER_FILES_DIR=$GRUPO/$MASTER_FILES_DIR
	fi
}

updateMaster() {
	echo -n "Actual master files directory is $MASTER_FILES_DIR, would you like to change it [Y/N]? "

	while true; do
		read UPDATE_OPTION
		UPDATE_OPTION=${UPDATE_OPTION^^}
		
		if [[ "YES" == *"$UPDATE_OPTION"* ]]; then
			inputMaster
			break
		elif [[ "NO" == *"$UPDATE_OPTION"* ]]; then
			break
		else
			echo -n "Wrong option. Retype [Y/N]: "
		fi
	done
}

inputArrival() {
	echo -n "Type the arrival files directory, followed by [ENTER] ($GRUPO/arrival): "
	read ARRIVAL_DIR

	if [ "$ARRIVAL_DIR" == "" ]; then
		ARRIVAL_DIR=$GRUPO/arrival
	else
		ARRIVAL_DIR=$GRUPO/$ARRIVAL_DIR
	fi
}

updateArrival() {
	echo -n "Actual arrival files directory is $ARRIVAL_DIR, would you like to change it [Y/N]? "

	while true; do
		read UPDATE_OPTION
		UPDATE_OPTION=${UPDATE_OPTION^^}
		
		if [[ "YES" == *"$UPDATE_OPTION"* ]]; then
			inputArrival
			break
		elif [[ "NO" == *"$UPDATE_OPTION"* ]]; then
			break
		else
			echo -n "Wrong option. Retype [Y/N]: "
		fi
	done
}

inputAccepted() {
	echo -n "Type the accepted files directory, followed by [ENTER] ($GRUPO/accepted): "
	read ACCEPTED_DIR

	if [ "$ACCEPTED_DIR" == "" ]; then
		ACCEPTED_DIR=$GRUPO/accepted
	else
		ACCEPTED_DIR=$GRUPO/$ACCEPTED_DIR
	fi
}

updateAccepted() {
	echo -n "Actual accepted files directory is $ACCEPTED_DIR, would you like to change it [Y/N]? "

	while true; do
		read UPDATE_OPTION
		UPDATE_OPTION=${UPDATE_OPTION^^}
		
		if [[ "YES" == *"$UPDATE_OPTION"* ]]; then
			inputAccepted
			break
		elif [[ "NO" == *"$UPDATE_OPTION"* ]]; then
			break
		else
			echo -n "Wrong option. Retype [Y/N]: "
		fi
	done
}

inputRejected() {
	echo -n "Type the rejected files directory, followed by [ENTER] ($GRUPO/rejected): "
	read REJECTED_DIR

	if [ "$REJECTED_DIR" == "" ]; then
		REJECTED_DIR=$GRUPO/rejected
	else
		REJECTED_DIR=$GRUPO/$REJECTED_DIR
	fi
}

updateRejected() {
	echo -n "Actual rejected files directory is $REJECTED_DIR, would you like to change it [Y/N]? "

	while true; do
		read UPDATE_OPTION
		UPDATE_OPTION=${UPDATE_OPTION^^}
		
		if [[ "YES" == *"$UPDATE_OPTION"* ]]; then
			inputRejected
			break
		elif [[ "NO" == *"$UPDATE_OPTION"* ]]; then
			break
		else
			echo -n "Wrong option. Retype [Y/N]: "
		fi
	done
}

inputProcessed() {
	echo -n "Type the processed files directory, followed by [ENTER] ($GRUPO/processed): "
	read PROCESSED_DIR

	if [ "$PROCESSED_DIR" == "" ]; then
		PROCESSED_DIR=$GRUPO/processed
	else
		PROCESSED_DIR=$GRUPO/$PROCESSED_DIR
	fi
}

updateProcessed() {
	echo -n "Actual processed files directory is $PROCESSED_DIR, would you like to change it [Y/N]? "

	while true; do
		read UPDATE_OPTION
		UPDATE_OPTION=${UPDATE_OPTION^^}
		
		if [[ "YES" == *"$UPDATE_OPTION"* ]]; then
			inputProcessed
			break
		elif [[ "NO" == *"$UPDATE_OPTION"* ]]; then
			break
		else
			echo -n "Wrong option. Retype [Y/N]: "
		fi
	done
}

inputReports() {
	echo -n "Type the reports directory, followed by [ENTER] ($GRUPO/reports): "
	read REPORTS_DIR

	if [ "$REPORTS_DIR" == "" ]; then
		REPORTS_DIR=$GRUPO/reports
	else
		REPORTS_DIR=$GRUPO/$REPORTS_DIR
	fi
}

updateReports() {
	echo -n "Actual report files directory is $REPORTS_DIR, would you like to change it [Y/N]? "

	while true; do
		read UPDATE_OPTION
		UPDATE_OPTION=${UPDATE_OPTION^^}
		
		if [[ "YES" == *"$UPDATE_OPTION"* ]]; then
			inputReports
			break
		elif [[ "NO" == *"$UPDATE_OPTION"* ]]; then
			break
		else
			echo -n "Wrong option. Retype [Y/N]: "
		fi
	done
}

inputLogs() {
	echo -n "Type the logs directory, followed by [ENTER] ($GRUPO/logs): "
	read LOGS_DIR

	if [ $"LOGS_DIR" == "" ]; then
		LOGS_DIR=$GRUPO/logs
	else
		LOGS_DIR=$GRUPO/$LOGS_DIR
	fi
}

updateLogs() {
	echo -n "Actual log files directory is $LOGS_DIR, would you like to change it [Y/N]? "

	while true; do
		read UPDATE_OPTION
		UPDATE_OPTION=${UPDATE_OPTION^^}
		
		if [[ "YES" == *"$UPDATE_OPTION"* ]]; then
			inputLogs
			break
		elif [[ "NO" == *"$UPDATE_OPTION"* ]]; then
			break
		else
			echo -n "Wrong option. Retype [Y/N]: "
		fi
	done
}

loadingBar() {
	for it in $(seq 1 40); do 
		echo -n "-"
		sleep 0.025
	done
	echo ">"
}

actualConfiguration() {
	echo "Executables files' directory: $EXE_FILES_DIR"
	echo "Master files directory: $MASTER_FILES_DIR"
	echo "Arrival files directory: $ARRIVAL_DIR"
	echo "Accepted files directory: $ACCEPTED_DIR"
	echo "Rejected files directory: $REJECTED_DIR"
	echo "Processed files directoty $PROCESSED_DIR"
	echo "Reports directory: $REPORTS_DIR"
	echo "Logs directory: $LOGS_DIR"
	echo -n "Do you want to continue with the previous configuration [Y/N]? "

	while true; do
		read INPUT
		INPUT=${INPUT^^}

		if [[ "YES" == *"$INPUT"* ]]; then
			CONFIG_ACCEPTED=1
			break
		elif [[ "NO" == *"$INPUT"* ]]; then
			CONFIG_ACCEPTED=0
			break
		else
			echo -n "Wrong option. Retype [Y/N]: "
		fi
	done
	
}

firstDataInput() {
	PERL_VERSION=$(perl -v | grep "This is perl *"  | sed 's-\(.*\)(v\(.*\))\(.*\)-\2-g')
	if ((${PERL_VERSION:0:1} < 5)); then
		echo "An upgrade in PERL is required to continue with the software installation. Please, install at lease PERL 5.0.0 and try again later (maybe using sudo apt-get perl)."
		CONTROL_INSTALLATION=1
	fi

	if [ ! -d "$HOME/Grupo06" ]; then
  		mkdir $GRUPO
	fi

	inputExecutables
	inputMaster
	inputArrival
	inputAccepted
	inputRejected
	inputProcessed
	inputReports
	inputLogs

	loadingBar
	actualConfiguration
}

updateDataInput() {
	updateExecutables
	updateMaster
	updateArrival
	updateAccepted
	updateRejected
	updateProcessed
	updateReports
	updateLogs

	loadingBar
	actualConfiguration
}

controlName
echo "Welcome to the CONTROL installation tutorial."
echo "Your directory structure will be generated in $HOME/Grupo06."
GRUPO=$HOME/Grupo06

loadingBar
firstDataInput

while [ $CONFIG_ACCEPTED == 0 ]; do
	loadingBar
	updateDataInput
done

mkdir -p "$EXE_FILES_DIR"
mkdir -p "$MASTER_FILES_DIR"
mkdir -p "$ARRIVAL_DIR"
mkdir -p "$ACCEPTED_DIR"
mkdir -p "$REJECTED_DIR"
mkdir -p "$PROCESSED_DIR"
mkdir -p "$REPORTS_DIR"
mkdir -p "$LOGS_DIR"

loadingBar
echo "Installation completed!"