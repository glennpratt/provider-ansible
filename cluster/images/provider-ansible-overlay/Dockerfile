# Replaces only the provider binary in a published provider-ansible package.
#
# The published package is the runtime image plus package metadata layers, so
# everything else (python, ansible, git, openssh, CRDs) is byte-for-byte the
# base release. Use this to test controller changes without changing the
# ansible runtime. Build with ./build.sh.
ARG BASE=index.docker.io/crossplanecontrib/provider-ansible:v0.6.0
FROM ${BASE}

ARG TARGETOS
ARG TARGETARCH
COPY bin/${TARGETOS}_${TARGETARCH}/provider /usr/local/bin/crossplane-ansible-provider
