#!/bin/bash -ex
date
time docker pull restic/restic
date
time docker run --rm --env-file=/opt/mycloud/restic/.env -v /var/lib/docker/volumes/:/data/volumes:ro -v /opt:/data/opt:ro -h olsonsky restic/restic backup /data && \
    date && \
    time docker run --rm --env-file=/opt/mycloud/restic/.env -h olsonsky restic/restic forget --keep-hourly 24 --keep-daily 30 && \
    date && \
    time docker run --rm --env-file=/opt/mycloud/restic/.env restic/restic snapshots && \
    date
