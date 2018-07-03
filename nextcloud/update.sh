#!/bin/bash
cd /opt/mycloud/nextcloud &&
docker-compose pull &&
docker-compose up -d &&
echo "updated docker"
