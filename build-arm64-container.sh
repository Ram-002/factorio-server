#!/bin/bash
set -x

pull=$(buildah from --pull docker://docker.io/library/ubuntu:latest)
buildah run $pull apt update
buildah run $pull bash -c 'env DEBIAN_FRONTEND=noninteractive apt install wget tar xz-utils -y'
buildah run $pull wget 'https://www.factorio.com/get-download/1.1.37/headless/linux64' -O /tmp/factorio
buildah run $pull tar -xf /tmp/factorio -C /opt

container=$(buildah from --pull docker://docker.io/library/ubuntu:latest)
buildah run $container apt update
buildah run $container bash -c 'env DEBIAN_FRONTEND=noninteractive apt upgrade -y'
buildah run $container bash -c 'env DEBIAN_FRONTEND=noninteractive apt install libc6-amd64-cross qemu-user -y'

pullmount=$(buildah mount $pull)
buildah copy $container $pullmount/opt /opt
buildah run $container mkdir -p /opt/factorio/saves
buildah umount $pull
buildah rm "$pull"

buildah config --entrypoint='["/bin/qemu-x86_64", "-L", "/usr/x86_64-linux-gnu", "/opt/factorio/bin/x64/factorio"]' $container
buildah config --cmd "--help" $container
buildah config --port 34197 $container

buildah commit $container factorio-server:1.1.37
buildah rm $container
