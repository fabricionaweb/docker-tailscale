Just another tailscale image. But compiled from the source.

---

**Environments**

Upstream environments available https://tailscale.com/kb/1282/docker#parameters.

- `TS_ACCEPT_DNS=true` to use magicdns, default is false
- `TS_HOSTNAME=container` add hostname
- `TS_EXTRA_ARGS=--advertise-exit-node --accept-routes` change as needed https://tailscale.com/kb/1080/cli
- `TS_AUTHKEY=` generate a key on tailscale panel (if ephemeral you dont need to mount /config)

**Needed docker arguments**

- `--cap-add=NET_ADMIN --cap-add=SYS_MODULE`
- `--sysctl="net.ipv6.conf.all.forwarding=1"`

**Needed docker devices**

- `--device=/dev/net/tun:/dev/net/tun` Maybe not needed when passing the caps, not sure.
