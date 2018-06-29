#!/bin/bash
docker pull restic/restic
docker run --rm --env-file=/opt/restic/.env -v /var/lib/docker/volumes/:/data/volumes:ro -v /opt:/data/opt:ro -h olsonsky restic/restic backup /data &&
docker run --rm --env-file=/opt/restic/.env restic/restic forget --keep-hourly 24 --keep-daily 30 &&
docker run --rm -it --env-file=/opt/restic/.env restic/restic snapshots
