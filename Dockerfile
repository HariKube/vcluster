ARG VERSION=v0.0.0
FROM ghcr.io/loft-sh/vcluster-pro:${VERSION} AS build

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
USER 65534

WORKDIR /

COPY --from=build /vcluster /vcluster
COPY --from=build /usr/local/bin/kine /usr/local/bin/kine
COPY --from=build /usr/local/bin/helm /usr/local/bin/helm
COPY --from=build /usr/local/bin/etcd /usr/local/bin/etcd
COPY --from=build /usr/local/bin/etcdctl /usr/local/bin/etcdctl
COPY --from=build /usr/local/bin/konnectivity-server /usr/local/bin/konnectivity-server

ENTRYPOINT ["/vcluster" "start"]
