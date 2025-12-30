# Config for person servers

## Description:

Current primary config under `server/` for homelab running on dellmini at 192.168.1.107

## System config:

- For podman user space systemd: `systemctl --user enable podman-restart.service`
- For podman non-root containers to persist: `loginctl enable-linger $USER`
- .env files set `VOLUME_DIR=/shared/volumes` location on NAS
- For podlab manual build see Dockerfile in: https://github.com/thenomemac/podlab
