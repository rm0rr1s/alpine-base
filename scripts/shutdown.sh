#! /bin/bash

# script to send signal to child processes started by bash scripts,
# as bash does NOT forward signals to child processes.
#
# example call to this script using supervisor shown below:-
#
#[program:shutdown-script]
#autorestart = false
#startsecs = 0
#user = root
#command = /usr/local/sbin/shutdown.sh '^/usr/bin/rtorrent,/home/media/bin/nginx'
#umask = 000

process="${1}"
signal="${2}"

# if process not defined then exit
if [ -z "${process}" ]; then
    echo "[crit] Full process path not specified as parameter 1, exiting script ..."
    exit 1
else
    echo "[info] Process is '${process}'"
fi

# split comma separated string into list from process_list
IFS=',' read -ra process_list <<< "${process}"

# if signal not defined then default to '15' (SIGTERM - terminate whenever/soft kill, typically sends SIGHUP as well)
if [ -z "${signal}" ]; then
        signal=15
fi

function get_pid(){
        pid=$(pgrep -f "${process_item}")
        if [ -z "${pid}" ]; then
                echo "[info] pid does not exist for process '${process_item}', process not running yet?"
        else
                echo "[info] pid is '${pid}' for process '${process_item}'"
        fi
}

function kill_process(){
    if [ -n "${pids}" ]; then
        while kill -${signal} ${pids} > /dev/null 2>&1; do
            sleep 0.1s
         done
    fi
    exit 0
}

function init_shutdown(){
    for process_item in "${process_list[@]}"; do
        # get pid of process
        get_pid
        pids+="${pid} "
    done
    kill_process
}

# kill process on trap
echo "[info] Initialising shutdown of process(es)"
trap "init_shutdown" SIGINT SIGTERM

# run indefinite sleep, using wait to allow us to interrupt sleep process
sleep infinity &
wait
