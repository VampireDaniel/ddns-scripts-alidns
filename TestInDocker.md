# Test OpenWrt ddns-scripts-alidns in Docker on macOS

This guide shows how to build and test the OpenWrt ddns-scripts-alidns extension using Docker on macOS.

---

## 1. Prerequisites
- [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop) installed
- Project source code directory (`ddns-scripts-alidns`) available

---

## 2. Create Dockerfile
Create a `Dockerfile` in your project root with the following content (for x86_64 target as example):

```Dockerfile
FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y build-essential git wget unzip python3 python3-distutils python3-setuptools \
    subversion libncurses5-dev zlib1g-dev gawk flex gettext libssl-dev xsltproc rsync \
    file wget curl && \
    apt-get clean

WORKDIR /build

# Download OpenWrt SDK (change version/target as needed)
RUN wget https://downloads.openwrt.org/releases/23.05.0/targets/x86/64/openwrt-sdk-23.05.0-x86-64_gcc-12.3.0_musl.Linux-x86_64.tar.xz && \
    tar xf openwrt-sdk-23.05.0-x86-64_gcc-12.3.0_musl.Linux-x86_64.tar.xz && \
    mv openwrt-sdk-23.05.0-x86-64_gcc-12.3.0_musl.Linux-x86_64 sdk

WORKDIR /build/sdk
```

---

## 3. Build Docker Image

```sh
docker build -t openwrt-sdk .
```

---

## 4. Start Container and Mount Your Package

```sh
docker run -it --rm -v "$PWD/ddns-scripts-alidns":/build/sdk/package/ddns-scripts-alidns openwrt-sdk /bin/bash
```

---

## 5. Build Your Package in the Container

```sh
./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig
# Select Network -> ddns-scripts-alidns, save and exit
make package/ddns-scripts-alidns/compile V=s
```

The compiled `.ipk` package will be in `/build/sdk/bin/packages/x86_64/base/` (or similar directory).

---

## 6. Copy the .ipk Out and Install on Your Router

```sh
# Execute outside the container
scp ddns-scripts-alidns_*.ipk root@<router_ip>:/tmp/
ssh root@<router_ip>
opkg install /tmp/ddns-scripts-alidns_*.ipk
```

---

## 7. Clean Up
After exiting the container, you can clean up Docker images and containers using `docker rm`, `docker rmi`.

---

## 8. Notes
- You can modify the SDK download link in the Dockerfile according to your actual OpenWrt target architecture.
- It's recommended to compile on Linux, using Docker on macOS can avoid compatibility issues.
- Compilation time is long, please be patient.

---

Contact us if you have any questions! 