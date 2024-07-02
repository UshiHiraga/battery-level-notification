#!/bin/bash
# A simple program to check changes at battery level.

message(){
    if [ "$?" == "0" ]; then
        echo "Script executed succesfully."
    else
        echo "Script had a problem."
    fi
}

BATTERY_NAME=$1;
PREV_BATTERY_LEVEL=$(cat /sys/class/power_supply/${BATTERY_NAME}/capacity);
CONFIG_FOLDER=$HOME/.config/battery-level-notification/${BATTERY_NAME};

## Set default values and load user config if exists.
SLEEP_TIME=5;
EXEC_PATH="";
if test -x $CONFIG_FOLDER/config; then source ${CONFIG_FOLDER}/config; fi

while true; do
    sleep $SLEEP_TIME;
    
    CURR_BATTERY_LEVEL=$(cat /sys/class/power_supply/${BATTERY_NAME}/capacity);
    if [ $CURR_BATTERY_LEVEL == $PREV_BATTERY_LEVEL ]; then
        echo "Battery level has not changed.";
        continue;
    fi
    
    PREV_BATTERY_LEVEL="$CURR_BATTERY_LEVEL";
    BATTERY_STATUS=$(cat /sys/class/power_supply/${BATTERY_NAME}/status);
    
    if ! test -z $EXEC_PATH && test -x $EXEC_PATH; then
        bash $EXEC_PATH $CURR_BATTERY_LEVEL $BATTERY_STATUS;
        message
        continue;
    fi
    
    if test -x ${CONFIG_FOLDER}/script; then
        bash ${CONFIG_FOLDER}/script $CURR_BATTERY_LEVEL $BATTERY_STATUS;
        message
        continue;
    fi
    
    echo "No script. Skipping.";
done