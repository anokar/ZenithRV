FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG ZIG_VERSION=0.16.0-dev.2682+02142a54d
ARG ZIG_ARCH=x86_64-linux

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    xz-utils \
    qemu-system-misc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN curl -fL "https://ziglang.org/builds/zig-${ZIG_ARCH}-${ZIG_VERSION}.tar.xz" -o zig.tar.xz \
    && tar -xf zig.tar.xz \
    && ln -s "/opt/zig-${ZIG_ARCH}-${ZIG_VERSION}/zig" /usr/local/bin/zig \
    && rm zig.tar.xz

WORKDIR /workspace
CMD ["bash"]
