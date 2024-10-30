Just another tailscale image. But compiled from the source.

---

**Environments**

Upstream environments available https://tailscale.com/kb/1282/docker#parameters.

- `TS_USERSPACE=false` disable userspace (default is enable) to use /dev/tun

**Needed docker arguments**

- `--cap-add=NET_ADMIN --cap-add=SYS_MODULE`

**Needed docker devices**

- `--device=/dev/net/tun:/dev/net/tun`
