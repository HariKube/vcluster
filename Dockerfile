ARG VERSION=v0.0.0
FROM ghcr.io/loft-sh/vcluster-pro:${VERSION} AS build

FROM --platform=linux/$BUILDARCH busybox:latest AS tmp
RUN mkdir -p /tmp/rootfs/tmp /tmp/rootfs/data /tmp/vclusterfs/vcluster
RUN chmod -R 775 /tmp/rootfs/tmp /tmp/rootfs/data /tmp/vclusterfs/vcluster

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
COPY --from=tmp --chown=65534:0 /tmp/vclusterfs/vcluster /var/lib/vcluster
COPY --from=build --chown=65534:0 /vcluster /vcluster
COPY --from=build --chown=65534:0 /usr/local/bin/* /usr/local/bin

USER 65534

WORKDIR /

ENTRYPOINT ["/vcluster", "start"]
