#!/bin/bash
cd mail &&
docker-compose pull &&
docker-compose up -d &&
cd ../ &
cd nextcloud &&
docker-compose pull &&
docker-compose up -d &&
echo "updated all mycloud docker"
