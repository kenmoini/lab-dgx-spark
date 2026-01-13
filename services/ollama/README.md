# Ollama

Ollama is a great little LLM runtime that is very user-friendly.  While it may not be as tweak-friendly as something like VLLM, it is quickly catching up with things like multi-model serving.

I run Ollama on my Spark via a container - this lets me easily test a model with a runtime that is very simple to use and debug.

```yaml
services:
  ollama:
    image: ollama/ollama
    container_name: ollama
    networks:
      - proxy
    extra_hosts:
      - host.docker.internal:host-gateway
    labels:
      # Labels for injection into Traefik
      - "traefik.enable=true"
      - "traefik.docker.network=proxy"
      - "traefik.http.routers.ollama.entrypoints=web,websecure"
      - "traefik.http.routers.ollama.service=ollama"
      - "traefik.http.routers.ollama.tls=true"
      - "traefik.http.routers.ollama.rule=Host(`ollama.YOUR_SPARK_IP.traefik.me`)"
      - "traefik.http.services.ollama.loadbalancer.server.port=11434"
      # Labels for injection into Homepage
      - "homepage.group=AI Services"
      - "homepage.name=Ollama"
      - "homepage.icon=sh-ollama"
      - "homepage.href=https://ollama.YOUR_SPARK_IP.traefik.me"
      - "homepage.description=Ollama LLM Management Interface"
    expose:
      - 11434
    volumes:
      # Mount system root store
      - /etc/ssl/certs/:/etc/ssl/certs/:ro
      # LLM Cache Directories
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
    restart: unless-stopped

networks:
  proxy:
    name: proxy
    external: true # enable if the network is not defined in this stack
```