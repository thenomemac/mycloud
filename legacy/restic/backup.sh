#!/bin/bash -ex
date
time docker pull restic/restic
date
BHOSTNAME="mail.olsonsky.com"
# -v /var/lib/docker/volumes/:/data/volumes:ro \
time docker run --rm --env-file=/opt/mycloud/restic/.env \
     -v /mailu/:/data/mailu:ro \
     -v /opt:/data/opt:ro \
     -h $BHOSTNAME restic/restic backup /data && \
    date && \
    time docker run --rm --env-file=/opt/mycloud/restic/.env -h $BHOSTNAME restic/restic forget --keep-hourly 24 --keep-daily 30 && \
    date && \
    time docker run --rm --env-file=/opt/mycloud/restic/.env -h $BHOSTNAME restic/restic snapshots && \
    date
