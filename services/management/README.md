# Management Stack

While doing things via the CLI is good and dandy for some, I like some clicky controls and glue.

- For general container management, [Portainer](https://github.com/portainer/portainer) is a great option.
- [Traefik](https://github.com/traefik/traefik) lets you easily reverse proxy services for unified ingress and TLS termination.
- [Homepage](https://github.com/gethomepage/homepage) is a nice and simple landing page for all your services so you don't have to keep bookmarks and track.
- Additionally a [Docker TCP Proxy](https://github.com/Tecnativa/docker-socket-proxy) is handy to limit administrative access to services that need to interact with Docker.

> For example configuration see [/workdir/mgmt](../../workdir/mgmt/)