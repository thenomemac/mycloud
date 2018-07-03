#!/bin/bash
cd /opt/mycloud/mail &&
docker-compose pull &&
docker-compose up -d &&
echo "updated docker"
