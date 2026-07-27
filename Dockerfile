ARG VERSION=v0.0.0
FROM ghcr.io/loft-sh/vcluster-pro:${VERSION} AS build

FROM --platform=linux/$BUILDARCH busybox:latest AS tmp
RUN mkdir -p /tmp/rootfs/tmp /tmp/rootfs/usr/local/bin /tmp/rootfs/db
RUN chmod -R 775 /tmp/rootfs/tmp /tmp/rootfs/usr/local/bin /tmp/rootfs/db
COPY --from=build /vcluster /tmp/rootfs/vcluster
COPY --from=build /usr/local/bin/kine /tmp/rootfs/usr/local/bin/kine
COPY --from=build /usr/local/bin/helm /tmp/rootfs/usr/local/bin/helm
COPY --from=build /usr/local/bin/etcd /tmp/rootfs/usr/local/bin/etcd
COPY --from=build /usr/local/bin/etcdctl /tmp/rootfs/usr/local/bin/etcdctl
COPY --from=build /usr/local/bin/konnectivity-server /tmp/rootfs/usr/local/bin/konnectivity-server

FROM registry.access.redhat.com/ubi9/ubi-minimal:latest
ARG VERSION
LABEL name="vCluster"
LABEL vendor="inspirNation Bt."
LABEL version="${VERSION}"
LABEL release="0"
LABEL summary="vCluster HariKube Edition"
LABEL description="vCluster HariKube edition is a RedHat compatible version."
LABEL maintainer="richard.kovacs@harikube.com"
COPY LICENSE /licenses/LICENSE
COPY --from=tmp --chown=65534:0 /tmp/rootfs/* /
USER 65534

WORKDIR /

ENTRYPOINT ["/vcluster" "start"]
