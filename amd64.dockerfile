FROM docker.io/library/ubuntu:latest

ARG FACTORIO_VERSION="1.1.68"

RUN env DEBIAN_FRONTEND=noninteractive && apt-get update -q && apt-get install wget tar xz-utils -y -q && \
    wget --progress=dot:mega "https://www.factorio.com/get-download/$FACTORIO_VERSION/headless/linux64" && \
    tar -xf /linux64 -C /opt --checkpoint=.100

FROM docker.io/library/ubuntu:latest

COPY --from=0 /opt/factorio /opt/factorio

ENTRYPOINT ["/opt/factorio/bin/x64/factorio"]

EXPOSE 34197

CMD ["--help"]

