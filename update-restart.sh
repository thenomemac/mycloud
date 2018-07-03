#!/bin/bash
cd mail
docker-compose pull
docker-compose up -d
cd nextcloud
docker-compose pull
docker-compose up -d
