#!/bin/bash -ex
/usr/bin/docker image prune -af && [ $(df -H / | awk '{ print $5 }' | tail -n1 | cut -d'%' -f1) -lt 90 ] && echo 'mytmp'
