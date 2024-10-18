#!/usr/bin/env bash

INOTIFYWAIT_SCRIPT="${INOTIFYWAIT_SCRIPT:-"/inotifywait.sh"}"

INOTIFY_TARGET="${INOTIFY_TARGET:-}"
INOTIFY_SCRIPT="${INOTIFY_SCRIPT:-}"

if [ -z "${INOTIFY_TARGET+x}" ]; then
    echo "no target declared. exiting." >&2
    exit 1
fi
if [ -z "${INOTIFY_SCRIPT+x}" ]; then
    echo "no script declared. exiting." >&2
    exit 1
fi

# Add execution permission to INOTIFY_SCRIPT
chmod +x "${INOTIFY_SCRIPT}"

# Load modules
asterisk_modules_dir="/usr/lib/asterisk/modules"
new_modules_dir="/opt/volumes/modules"
for module in $(ls $new_modules_dir/); do
    if [ ! -f $asterisk_modules_dir/$module ]; then
        cp -v $new_modules_dir/$module $asterisk_modules_dir/
        chmod u+x $asterisk_modules_dir/$module
    fi
done

# Start asterisk
asterisk -f &

if [ "$1" = "inotify-script" ]; then
    echo "[$(date -Iseconds)] running ${INOTIFYWAIT_SCRIPT}"
    exec "${INOTIFYWAIT_SCRIPT}" "${INOTIFY_TARGET}" "${INOTIFY_SCRIPT}"
else
    exec "${@}"
fi
