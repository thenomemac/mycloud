# Config for personal servers

## Description:

Current primary config under `server/` for homelab running on dellmini at 192.168.1.107

## System config:

- For podman user space systemd: `systemctl --user enable podman-restart.service`
- For podman non-root containers to persist: `loginctl enable-linger $USER`
- .env files set `VOLUME_DIR=/shared/volumes` location on NAS
- For podlab manual build see Dockerfile in: https://github.com/thenomemac/podlab

## FSTAB

```
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/ubuntu-vg/ubuntu-lv during curtin installation
/dev/disk/by-id/dm-uuid-LVM-YvofXDTlj6h6eeKEQTZp9hRpfZY1FcXuSjtAD9HCCqcOSLkd9mzUobHVICyNRmCP / ext4 defaults 0 1
# /boot was on /dev/nvme0n1p2 during curtin installation
/dev/disk/by-uuid/25f96140-2d80-4a1b-82f6-cb2704e1cc77 /boot ext4 defaults 0 1
# /boot/efi was on /dev/nvme0n1p1 during curtin installation
/dev/disk/by-uuid/139D-F20A /boot/efi vfat defaults 0 1
/swap.img       none    swap    sw      0       0
# onetbssd
UUID=6efa06ae-7442-4bad-8dcf-6d8756d549f6 /shared btrfs rw,noatime,ssd,discard=async,space_cache=v2,compress=zstd:1 0 0
```
