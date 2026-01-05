#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
ENV_FILE=$(echo ${SCRIPT_DIR}'/.env')

set +x
. $ENV_FILE
set -x

restic unlock
