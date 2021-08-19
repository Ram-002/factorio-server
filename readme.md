# Factorio server for ARM64

# Usage

Create save
```shell
mkdir saves
podman run --rm \
  --mount type=bind,src=./saves,dst=/opt/factorio/saves \
  docker.io/ram002/factorio-server:1.1.37 --create /opt/factorio/saves/save.zip
```

Start server 
```bash
podman run --rm -d \
  --name factorio \
  --mount type=bind,src=./saves,dst=/opt/factorio/saves \
  --publish 34197:34197/udp \
  docker.io/ram002/factorio-server:1.1.37 --start-server /opt/factorio/saves/save.zip
```

## Building
  
Creating container
```shell
buildah unshare ./build-factorio-container.sh
```
  
Pushing container
```shell
buildah push -f=v2s2 factorio-server:1.1.37 docker.io/ram002/factorio-server:1.1.37
```
