# Open WebUI

Open WebUI is an extensible, self-hosted AI interface that adapts to your workflow, all while operating entirely offline.

The NVIDIA guides didn't work or me via NVIDIA Sync, and just doing it manually was fine for a good test, but I'd rather run it as a Docker Compose Stack.

```yaml
services:
  open-webui:
    image: ghcr.io/open-webui/open-webui:ollama
    container_name: open-webui
    restart: unless-stopped
    networks:
      - proxy
    extra_hosts:
      - host.docker.internal:host-gateway
    expose:
      - 8080
    labels:
      # Labels for injection into Traefik
      - "traefik.enable=true"
      - "traefik.docker.network=proxy"
      - "traefik.http.routers.openwebui.entrypoints=web,websecure"
      - "traefik.http.routers.openwebui.service=openwebui"
      - "traefik.http.routers.openwebui.tls=true"
      - "traefik.http.routers.openwebui.rule=Host(`openwebui.YOUR_SPARK_IP.traefik.me`)"
      - "traefik.http.services.openwebui.loadbalancer.server.port=8080"
      # Labels for injection into Homepage
      - "homepage.group=AI Services"
      - "homepage.name=Open WebUI"
      - "homepage.icon=sh-open-webui-light"
      - "homepage.href=https://openwebui.YOUR_SPARK_IP.traefik.me"
      - "homepage.description=Open WebUI Chat Interface"
    volumes:
      - open-webui:/app/backend/data
      # Mount the system root store
      - /etc/ssl/certs/:/etc/ssl/certs/:ro
      # Cache Directory Mounts
      - /opt/workdir/llm-cache/huggingface:/llm-cache/huggingface
      - /opt/workdir/llm-cache/torchinductor:/llm-cache/torchinductor
      - /opt/workdir/llm-cache/ollama:/root/.ollama
    environment:
      - HF_HOME=/llm-cache/huggingface
      - TORCHINDUCTOR_CACHE_DIR=/llm-cache/torchinductor
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              capabilities: [gpu]

volumes:
  open-webui:

networks:
  proxy:
    name: proxy
    external: true # enable if the network is not defined in this stack
```

With that you should be able to access the Open WebUI interface either on port 8080 or via the Traefik route.  First thing it'll do is ask to sign up, and then from there you can start loading models and chatting with them!

