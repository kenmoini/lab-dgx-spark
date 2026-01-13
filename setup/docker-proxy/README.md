# Docker Proxy

Sometimes you want to give a service read access to parts of Docker and not just blanket read access to the socket.  This is where a Docker Proxy comes in handy.

Clients can communicate to Docker via a Socket or via TCP endpoint - using a little middleware, you can connect to the socket, expose a TCP endpoint, and then limit access.

```yaml
# https://github.com/Tecnativa/docker-socket-proxy
services:
  docker_proxy:
    image: tecnativa/docker-socket-proxy
    container_name: mgmt-docker-proxy
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    environment:
      OTEL_SERVICE_NAME: homepage
      CONTAINERS: 1
      SERVICES: 1
      DISTRIBUTION: 1
      EVENTS: 1
      STATS: 1
      GRPC: 1
      IMAGES: 1
      INFO: 1
      NETWORKS: 1
      NODES: 1
      VOLUMES: 1
      SESSION: 1
    restart: always
    networks:
      - proxy
    security_opt:
      - no-new-privileges:true
    group_add:
      - 988 # docker groupid on the host system if it's different
    ports:
      - "2375:2375"  # Expose the Docker API over TCP (optional, be cautious)

networks:
  proxy:
    name: proxy
    external: true # enable if the network is not defined in this stack

```

With that Docker Compose file up and running you can then set the Docker Endpoint to `tcp://mgmt-docker-proxy:2375` instead of `/var/run/docker.socket`

Not needed really, but it's nice for limiting access and preventing lateral movement.
