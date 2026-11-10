# Using shinyproxy-docker

This is a customization of shinyproxy for KTH. 

Differences versus the official image:

- KTH favicon is built into the container image.
- Uses Java 25 LTS (eclipse-temurin:25-jre-resolute / Ubuntu 26.04).

## Links

Documentation and release notes:

- https://shinyproxy.io/
- https://shinyproxy.io/downloads/#324

## Local development

The `compose.yaml` sets up a local stack with nginx-proxy and ShinyProxy for testing.
`application-oidc-local.yaml` uses KTH ADFS OIDC — the registered redirect URI is
`http://localhost:8080/login/oauth2/code/shinyproxy`.

```bash
docker compose up -d
# simple auth (application.yaml):  http://localhost:8000
# OIDC full flow:                   http://localhost:8080
```

### Gotchas with Podman and podman-compose

**Unqualified image names fail.** Podman requires fully-qualified image names
(`docker.io/nginx`, not `nginx`). Add `docker.io/` prefix if builds or pulls fail with
"short-name did not resolve to an alias".

**Privileged ports.** Rootless Podman cannot bind ports below 1024. Use a high port
locally (e.g. `8000:80`) or add `net.ipv4.ip_unprivileged_port_start=80` to
`/etc/sysctl.conf`.

**Container DNS does not forward external queries.** Podman's internal DNS resolver
(`aardvark-dns`) handles container-to-container name resolution but may not forward
external queries even when configured with an upstream. Workaround for local dev:
`network_mode: host` on the container that needs external DNS, combined with
`internal-networking: false` in the ShinyProxy app spec so it reaches app containers
via host-mapped ports rather than container hostnames.

**Docker socket path.** The rootless Podman socket is at
`/run/user/$(id -u)/podman/podman.sock`, not `/var/run/docker.sock`. Activate it with:
```bash
systemctl --user start podman.socket
```

**`dns:` key in compose is ignored.** podman-compose does not honour the `dns:`
service key — use `network_mode: host` or recreate the network with
`podman network create --dns <nameserver>` instead.

**`env_file` dotfiles.** A dotfile env file (e.g. `env/.shinyproxyenvkth`) must be
referenced with its dot prefix — `./env/.shinyproxyenvkth`, not `./env/shinyproxyenvkth`.
