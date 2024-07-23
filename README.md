# webauthn-proxy

[![GitHub main workflow](https://img.shields.io/github/actions/workflow/status/dmotte/webauthn-proxy/main.yml?branch=main&logo=github&label=main&style=flat-square)](https://github.com/dmotte/webauthn-proxy/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/dmotte/webauthn-proxy?logo=docker&style=flat-square)](https://hub.docker.com/r/dmotte/webauthn-proxy)

This is a :whale: customization of the [`quiq/webauthn_proxy`](https://hub.docker.com/r/quiq/webauthn_proxy) Docker image.

GitHub repo of the upstream [**WebAuthn Proxy**](https://github.com/Quiq/webauthn_proxy) project: [Quiq/webauthn_proxy](https://github.com/Quiq/webauthn_proxy)

> :package: This image is also on **Docker Hub** as [`dmotte/webauthn-proxy`](https://hub.docker.com/r/dmotte/webauthn-proxy) and runs on **several architectures** (e.g. amd64, arm64, ...). To see the full list of supported platforms, please refer to the [`.github/workflows/main.yml`](.github/workflows/main.yml) file. If you need an architecture which is currently unsupported, feel free to open an issue.

## Usage

In this repo we also provide an example of how to protect services with **WebAuthn** using this image and [Traefik](https://traefik.io/), and expose the resulting stack through an **SSH reverse port forwarding tunnel** using [dmotte/docker-portmap-client](https://github.com/dmotte/docker-portmap-client). See the [`docker-compose.yml`](docker-compose.yml) file.

Note that this is meant to be run behind an **HTTPS &rarr; HTTP** reverse proxy.

### Set up portmap-client

First of all, you need to set up everything for the `portmap-client` docker-compose service. Basically you need to create the missing files into the [`volumes/portmap-client`](volumes/portmap-client) directory (see instructions in the [official repo](https://github.com/dmotte/docker-portmap-client)) and adjust the `command` field of the `portmap-client` service in the [`docker-compose.yml`](docker-compose.yml) file with the right values.

### Set up webauthn-proxy

Then you need to replace `example.com` with the right target **domain name** inside [`volumes/webauthn-proxy-config/config.yml`](volumes/webauthn-proxy-config/config.yml).

Create the `volumes/webauthn-proxy-config/credentials.yml` file starting from [`volumes/webauthn-proxy-config/credentials.sample.yml`](volumes/webauthn-proxy-config/credentials.sample.yml):

- It's important to generate and set a **cookie session secret** there, to avoid the following error after _WebAuthn Proxy_ restart:

  ```
  Error getting session from session store during user auth handler: securecookie: the value is not valid
  ```

  You can use the following command to **generate** a cookie session secret:

  ```bash
  docker run -it --rm docker.io/dmotte/webauthn-proxy:latest -generate-secret
  ```

- As for the `user_credentials` dictionary, you can leave it empty (`{}`) for now, and you'll populate it later, once someone **registers** in your _WebAuthn Proxy_ instance.

### Final steps

Finally, you may want to **further customize** the configuration files, so make sure to take one last look and check that everything is OK. When you are ready:

```bash
docker-compose up -d
```

Then you can visit the **public URL** of your exposed service and check that everything is working fine.

## Development

If you want to contribute to this project, you can use the following one-liner to **rebuild the image** and bring up the **Docker-Compose stack** every time you make a change to the code:

```bash
docker-compose down && docker-compose up --build
```
