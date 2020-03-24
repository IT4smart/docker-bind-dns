# IT4smart/docker-bind-dns:latest

- [Introduction](#introduction)
  - [Contributing](#contributing)
  - [Issues](#issues)
- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Quickstart](#quickstart)
  - [Command-line arguments](#command-line-arguments)
  - [Persistence](#persistence)
- [Maintenance](#maintenance)
  - [Upgrading](#upgrading)
  - [Shell Access](#shell-access)

# Introduction
This is a Bind DNS Server container for docker on debian which can run on Raspberry Pi (or whereever)
It is Forked from [lauster/rpi-bind-dns](https://github.com/Lauster/rpi-bind-dns).

The `Dockerfile` is used to create a [Docker](https://www.docker.com/) container image for [BIND](https://www.isc.org/downloads/bind/) DNS server.
The image originally had webmin installed also, but I removed it, since I have no use for it.

[BIND](https://www.isc.org/downloads/bind/) is open source software that implements the Domain Name System (DNS) protocols for the Internet. It is a reference implementation of those protocols, but it is also production-grade software, suitable for use in high-volume and high-reliability applications.

## Contributing

If you find this image useful here's how you can help:

- Send a pull request with your awesome features and bug fixes
- Help users resolve their [issues](../../issues?q=is%3Aopen+is%3Aissue).

## Issues

Before reporting your issue please try updating Docker to the latest version and check if it resolves the issue. Refer to the Docker [installation guide](https://docs.docker.com/installation) for instructions.

SELinux users should try disabling SELinux using the command `setenforce 0` to see if it resolves the issue.

If the above recommendations do not help then [report your issue](../../issues/new) along with the following information:

- Output of the `docker version` and `docker info` commands
- The `docker run` command or `docker-compose.yml` used to start the image. Mask out the sensitive bits.
- Please state if you are using [Boot2Docker](http://www.boot2docker.io), [VirtualBox](https://www.virtualbox.org), etc.

# Getting started

## Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/lauster/rpi-bind-dns) and is the recommended method of installation.


```bash
docker pull lauster/rpi-bind-dns:latest
```

Alternatively you can build the image yourself.

```bash
docker build -t lauster/rpi-bind-dns github.com/lauster/rpi-bind-dns
```

## Quickstart

Start BIND using:

```bash
docker run --name bind -d --restart=always \
  --publish 53:53/udp --publish 10000:10000 \
  --volume /srv/docker/bind:/data \
  it4smart/bind-dns:latest
```


## Command-line arguments

You can customize the launch command of BIND server by specifying arguments to `named` on the `docker run` command. For example the following command prints the help menu of `named` command:

```bash
docker run --name bind -it --rm \
  --publish 53:53/udp --publish 53:53/tcp \
  --volume /srv/docker/bind:/data \
  it4smart/bind-dns:latest -h
```

## Persistence

For BIND to preserve its state across container shutdown and startup you should mount a volume at `/data`.

> *The [Quickstart](#quickstart) command already mounts a volume for persistence.*

SELinux users should update the security context of the host mountpoint so that it plays nicely with Docker:

```bash
mkdir -p /srv/docker/bind
chcon -Rt svirt_sandbox_file_t /srv/docker/bind
```

# Maintenance

## Upgrading

To upgrade to newer releases:

  1. Download the updated Docker image:

  ```bash
  docker pull it4smart/bind-dns:latest
  ```

  2. Stop the currently running image:

  ```bash
  docker stop bind-dns
  ```

  3. Remove the stopped container

  ```bash
  docker rm -v bind-dns
  ```

  4. Start the updated image

  ```bash
  docker run -name bind-dns -d \
    [OPTIONS] \
    it4smart/bind-dns:latest
  ```

## Shell Access

For debugging and maintenance purposes you may want access the containers shell. If you are using Docker version `1.3.0` or higher you can access a running containers shell by starting `bash` using `docker exec`:

```bash
docker exec -it it4smart/bind-dns /bin/bash
```
