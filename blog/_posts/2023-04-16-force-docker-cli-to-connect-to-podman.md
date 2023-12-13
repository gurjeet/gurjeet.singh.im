---
layout: post
title:  "Force Docker CLI to connect to Podman, on macOS"
date:   2023-04-16 22:48:16 -0700
categories: Docker, Podman, macOS
---

Podman is a replacement of Docker. Podman does a great job of being compatible
with Docker's tools, utilities, etc. So if you have workflows, scripts, etc.
developed for Docker, rather than changing all of them, it's easier to simply
change one environment variable and let Docker tools believe that they're
communicating with Docker server, whereas, in reality, it's Podman that does the
real work.

On macOS, Podman runs inside a virtual machine. And it exposes its
communication channel as a Unix Domain Socket. So you can set the `DOCKER_HOST`
environment variable to point to Podman server's socket, and the Doccker CLI
utiliies will all work with Podman.

{% comment %}
Use 'raw' tag to prevent Jekyll from consuming the format string as a Liquid
variable. It does so because the format string is surrounded by {{ and }}.
{% endcomment %}

{% raw %}
```shell
export DOCKER_HOST="unix://$(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}')"
```
{% endraw %}

Rather than remembering that incantation, I turned it into a Bash function with
an easy-to-remember name, and some helpful diagnostics.

{% raw %}
```shell
function docker_set_host_to_podman_socket()
{
    local socket_path="$(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}')"
    local unix_domain_socket="unix://$socket_path"
    echo "Setting DOCKER_HOST=$unix_domain_socket"
    export DOCKER_HOST="$unix_domain_socket"
}
```
{% endraw %}
