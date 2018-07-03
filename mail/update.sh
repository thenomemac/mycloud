#!/bin/bash
cd /opt/mycloud/mail &&
/usr/local/bin/docker-compose pull &&
/usr/local/bin/docker-compose up -d &&
echo "updated docker"
