#!/bin/bash
cd /opt/mycloud/nextcloud &&
/usr/local/bin/docker-compose pull &&
/usr/local/bin/docker-compose up -d &&
echo "updated docker"
