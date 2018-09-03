#!/bin/bash -ex
docker pull restic/restic
docker run --rm --env-file=/opt/mycloud/restic/.env -v /var/lib/docker/volumes/:/data/volumes:ro -v /opt:/data/opt:ro -h olsonsky restic/restic backup /data &&
docker run --rm --env-file=/opt/mycloud/restic/.env -h olsonsky restic/restic forget --keep-hourly 24 --keep-daily 30 &&
docker run --rm --env-file=/opt/mycloud/restic/.env restic/restic snapshots
