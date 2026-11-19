#!/usr/bin/env bash
# Usage: build.sh <image:tag> [buildx args...]
#   e.g. build.sh ghcr.io/me/provider-ansible:v0.6.0-me.1 --push
# BASE overrides the published package to build on. BUILDX_BUILDER selects
# the buildx builder, as usual.
set -euo pipefail

image=${1:?usage: build.sh <image:tag> [buildx args...]}
shift

here=$(cd "$(dirname "$0")" && pwd)
root=$(cd "$here/../../.." && pwd)
ctx=$(mktemp -d)
trap 'rm -rf "$ctx"' EXIT

for arch in amd64 arm64; do
  (cd "$root" && CGO_ENABLED=0 GOOS=linux GOARCH=$arch \
    go build -trimpath -ldflags '-s -w' -o "$ctx/bin/linux_$arch/provider" ./cmd/provider)
done

docker buildx build "$ctx" -f "$here/Dockerfile" \
  --platform linux/amd64,linux/arm64 --provenance=false --sbom=false \
  --build-arg "BASE=${BASE:-index.docker.io/crossplanecontrib/provider-ansible:v0.6.0}" \
  -t "$image" "$@"
