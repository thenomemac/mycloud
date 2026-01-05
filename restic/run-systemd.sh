#!/bin/bash

# ex: https://www.mavjs.org/post/automatic-backup-restic-systemd-service/

echo "STARTING"

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
ENV_FILE=$(echo ${SCRIPT_DIR}'/.env')

echo "SCRIPT_DIR:"
echo $SCRIPT_DIR
echo "ENV_FILE:"
echo $ENV_FILE

set +x
. $ENV_FILE
set -x


restic snapshots

restic backup  --verbose --exclude=.cache --exclude=.local /shared/volumes /home

restic snapshots

echo "SUCCESS"
