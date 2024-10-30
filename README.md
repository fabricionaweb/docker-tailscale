Just another tailscale image. But compiled from the source.

---

**Environments**

Upstream environments available https://tailscale.com/kb/1282/docker#parameters.

- `TS_USERSPACE=false` disable userspace (default is enable) to use /dev/tun
- `TS_HOSTNAME=container` add hostname
- `TS_EXTRA_ARGS=--reset --advertise-exit-node --accept-routes` allow exit node / accept routes

**Needed docker arguments**

- `--cap-add=NET_ADMIN --cap-add=SYS_MODULE`
- `--sysctls net.ipv6.conf.all.forwarding=1`

**Needed docker devices**

- `--device=/dev/net/tun:/dev/net/tun`
