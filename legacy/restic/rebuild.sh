#!/bin/bash -ex

time docker run --rm --env-file=/opt/mycloud/restic/.env -v /var/lib/docker/volumes/:/data/volumes:ro -v /opt:/data/opt:ro -h olsonsky restic/restic unlock && echo "success"

time docker run --rm --env-file=/opt/mycloud/restic/.env -v /var/lib/docker/volumes/:/data/volumes:ro -v /opt:/data/opt:ro -h olsonsky restic/restic check && echo "success"

time docker run --rm --env-file=/opt/mycloud/restic/.env -v /var/lib/docker/volumes/:/data/volumes:ro -v /opt:/data/opt:ro -h olsonsky restic/restic rebuild-index && echo "success"

time docker run --rm --env-file=/opt/mycloud/restic/.env -v /var/lib/docker/volumes/:/data/volumes:ro -v /opt:/data/opt:ro -h olsonsky restic/restic check && echo "success"

time docker run --rm --env-file=/opt/mycloud/restic/.env -v /var/lib/docker/volumes/:/data/volumes:ro -v /opt:/data/opt:ro -h olsonsky restic/restic prune && echo "success"

time docker run --rm --env-file=/opt/mycloud/restic/.env -v /var/lib/docker/volumes/:/data/volumes:ro -v /opt:/data/opt:ro -h olsonsky restic/restic check && echo "success"

time docker run --rm --env-file=/opt/mycloud/restic/.env -v /var/lib/docker/volumes/:/data/volumes:ro -v /opt:/data/opt:ro -h olsonsky restic/restic backup /data && echo "success"

time docker run --rm --env-file=/opt/mycloud/restic/.env restic/restic snapshots && echo "success"
