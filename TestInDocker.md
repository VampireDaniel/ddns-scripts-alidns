# Test OpenWrt ddns-scripts-alidns in Docker on macOS

This guide shows how to build and test the OpenWrt ddns-scripts-alidns extension using Docker on macOS.  
本指南介绍如何在 macOS 上用 Docker 编译和测试 OpenWrt ddns-scripts-alidns 扩展。

---

## 1. Prerequisites 先决条件
- [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop) 已安装
- 已有本项目源码目录（`ddns-scripts-alidns`）

---

## 2. Create Dockerfile 新建 Dockerfile
在项目根目录新建 `Dockerfile`，内容如下（以 x86_64 为例）：

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

## 3. Build Docker Image 构建镜像

```sh
docker build -t openwrt-sdk .
```

---

## 4. Start Container and Mount Your Package 启动容器并挂载包目录

```sh
docker run -it --rm -v "$PWD/ddns-scripts-alidns":/build/sdk/package/ddns-scripts-alidns openwrt-sdk /bin/bash
```

---

## 5. Build Your Package in the Container 容器内编译包

```sh
./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig
# 选择 Network -> ddns-scripts-alidns，保存退出
make package/ddns-scripts-alidns/compile V=s
```

编译好的 `.ipk` 包会在 `/build/sdk/bin/packages/x86_64/base/`（或类似目录）。

---

## 6. Copy the .ipk Out and Install on Your Router 拷贝并安装到路由器

```sh
# 在容器外执行
scp ddns-scripts-alidns_*.ipk root@<router_ip>:/tmp/
ssh root@<router_ip>
opkg install /tmp/ddns-scripts-alidns_*.ipk
```

---

## 7. Clean Up 清理
退出容器后，Docker 镜像和容器可用 `docker rm`、`docker rmi` 清理。

---

## 8. Notes 注意事项
- 可根据实际 OpenWrt 目标架构修改 Dockerfile 里的 SDK 下载链接。
- 推荐在 Linux 下编译，macOS 下用 Docker 可避免兼容性问题。
- 编译时间较长，耐心等待。

---

如有问题请随时联系！ 