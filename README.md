# OlsonSky.com : mycloud
## my personal docker-ized cloud for nextcloud and email

**configuration as code repo**

All that's needed to redeploy `olsonsky.com` is run the `docker-compose up -d` in the directories `mail` and `nextcloud`.

This repo should be cloned into `/opt`:
```bash
cd /opt && git clone https://github.com/thenomemac/mycloud.git
```

To re-deploy:
```
cd /opt/mycloud/mail && docker-compose up -d;
cd /opt/mycloud/nextcloud && docker-compose up -d;
```
And setup DNS as outlined at: https://github.com/hardware/mailserver

Also, restore the backup docker volumes:
```
root@olson-cloud:/var/lib/docker/volumes# ls
mail_mailserver  mail_rainloop  mail_traefik  nextcloud_nextcloud
mail_postgres    mail_redis     metadata.db   nextcloud_pgsql
```

healthcheck.io to ensure the instance is up:
```
# crontab -l
33 */3 * * * curl -fsS --retry 3 https://hc-ping.com/<GUID> > /dev/null
3 * * * * bash /opt/mycloud/restic/backup.sh > /var/log/mycloud-backup.log 2>&1 && curl -fsS --retry 3 https://hc-ping.com/<GUID> > /dev/null
8 2 * * * bash /opt/mycloud/mail/update.sh && bash /opt/mycloud/nextcloud/update.sh && curl -fsS --retry 3 <GUID> > /dev/null

```
