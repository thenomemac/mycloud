# Raspberrypi homelab

## Setup

```bash
apt update && apt upgrade -y && apt install emacs htop tmux unattended-upgrades
```

### Storage

Mount usb storage on host via `/etc/fstab`. Don't forget to `mkdir` the mount dir.
```
LABEL=writable  /        ext4   defaults        0 0
LABEL=system-boot       /boot/firmware  vfat    defaults        0       1
UUID=4E1AEA7B1AEA6007     /media/wdpassport   auto    rw,user,auto    0    0
```

```bash
# to init mount
mkdir /media/wdpassport
mount /dev/sda /media/wdpassport
```

### Network

Setup bridge networking and a static mac address and setup bridge interface via `netplan apply`.
`ip: 192.168.1.106`

```yaml
# pi@raspberrypi:~$ cat /etc/netplan/50-cloud-init.yaml
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        eth0:
            dhcp4: true
            optional: true
    version: 2
    wifis:
        wlp3s0:
            optional: true
            access-points:
                olsonwifi:
                    password: "<>"
            dhcp4: true
    bridges:
        br0:
            macaddress: A6:E3:33:A5:57:FC
            dhcp4: true
            interfaces:
                - eth0
```

```bash
# to apply network
netplan apply --debug
# does not appear to be necessary to set this config?
# echo 'network: {config: disabled}' >> /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
```

### LXD

```yaml
config:
  cluster.https_address: 192.168.1.106:8443
  core.https_address: 192.168.1.106:8443
  core.trust_password: true
  # bitwarden or /home/pi/.joinlxd.yaml
networks:
- config:
    ipv4.address: 10.56.36.1/24
    ipv4.nat: "true"
    ipv6.address: fd42:967f:a893:8b37::1/64
    ipv6.nat: "true"
  description: ""
  name: lxdbr0
  type: bridge
- config:
    bridge.mode: fan
    fan.underlay_subnet: 192.168.1.0/24
  description: ""
  name: lxdfan0
  type: bridge
storage_pools:
- config:
    size: 15GB
    source: /var/snap/lxd/common/lxd/disks/local.img
  description: ""
  name: local
  driver: btrfs
profiles:
- config: {}
  description: both local br0 lan bridge and fan network profile
  devices:
    eth0:
      name: eth0
      nictype: bridged
      parent: br0
      type: nic
    eth1:
      name: eth1
      network: lxdbr0
      type: nic
    eth2:
      name: eth2
      network: lxdfan0
      type: nic
    root:
      path: /
      pool: local
      type: disk
  name: bridgeandfan
- config: {}
  description: bridge profile
  devices:
    eth0:
      name: eth0
      nictype: bridged
      parent: br0
      type: nic
    root:
      path: /
      pool: local
      type: disk
  name: bridgeprofile
- config: {}
  description: Default LXD profile
  devices:
    eth0:
      name: eth0
      network: lxdbr0
      type: nic
    root:
      path: /
      pool: local
      type: disk
  name: default
- config: {}
  description: Default LXD profile
  devices:
    eth0:
      name: eth0
      network: lxdfan0
      type: nic
    root:
      path: /
      pool: local
      type: disk
  name: fanprofile
- config: {}
  description: Profile for macvlan
  devices:
    eth0:
      name: eth0
      nictype: macvlan
      parent: eth0
      type: nic
    root:
      path: /
      pool: local
      type: disk
  name: macvlanprofile
```

Update all images nightly: `/etc/cron.daily/update-lxc-containers`
```bash
#!/bin/bash -ex
function updateall {
    lxc -c ns --format csv ls | grep RUNNING | cut -f1 -d',' | xargs -I{} bash -exc "echo 'updating-lxc: {}' && lxc exec {} -- apt update && lxc exec {} -- apt -y upgrade && lxc exec {} -- apt -y autoremove && echo 'success-updating-lxc: {}'" && echo "success update-lxc-containers"
}
if [ "$1" == "--all" ]; then
    updateall
else
    systemd-cat -t "$0" bash -ex "$0" --all
    # TODO: add healthcheck and snapshots
fi
```

### Disaster recovery

Add cloud backup and snapshot sending.

### NAS

Nas setup in `/etc/samba/smb.conf`:
```
ip: 192.168.1.112
username: pi
password: bitwarden
macaddress: 00:16:3e:53:81:5d
conn: smb://192.168.1.112/backup
```

storage mounts: `lxd config show pinas`
```yaml
devices:
  wdpassport:
    path: /media/wdpassport/
    source: /media/wdpassport/
    type: disk
```

### Wireguard

Running in LXC container "wgvpn". Network Setup, in container, via dhcp and netplan.
```
ip: 192.168.1.114
macaddress: 00:16:3e:8a:a8:f0
```

To relaunch write config:
```ini
# /etc/wireguard/wg0.conf 
[Interface]
Address = 10.0.0.1/24
Address = fd42:42:42::1/64
SaveConfig = true
PostUp = iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE; ip6tables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ListenPort = 51820
PrivateKey = <>
# PublicKey = 9Qpujn+VdlcaRcCk3aTkchYb6LhHkf8DjgH5KotLGHI=

[Peer]
# motog6
PublicKey = ITh2B1kgIqpc0vY/VagE3J4zl9a8YEKwoCVxFxEOlUI=
AllowedIPs = 10.0.0.2/32, fd42:42:42::2/128
```

Run to configure wireguard interface:
```bash
apt update && apt install wireguard
mkdir -p /etc/wireguard && cd /etc/wireguard && umask 077 && wg genkey | tee privatekey | wg pubkey > publickey
# wg-quick up wg0
systemctl start wg-quick@wg0
ip a
systemctl enable wg-quick@wg0
wg
```