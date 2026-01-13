# Management Services

This folder houses the configuration and deployment mechanisms for a "Management" stack that is made up of:

- Traefik for universal reverse proxying/load balancing
- Portainer for Container Management
- Homepage as a landing page to keep track of things

Additionally, this folder also typically would house things such as TLS certificates for Traefik.  Those are obviously not included but can be easily generated with [PikaPKI](https://github.com/kenmoini/pika-pki).