#!/usr/bin/env bash
# Regenerates requirements.txt from requirements.in with uv
# (https://docs.astral.sh/uv/). Extra arguments are passed to uv, e.g.
# --upgrade-package ansible-core. Keep --python-version in step with the
# Python of the base image in the Dockerfile.
set -euo pipefail
cd "$(dirname "$0")"
exec uv pip compile requirements.in -o requirements.txt \
  --python-version 3.13 --python-platform x86_64-unknown-linux-musl \
  --generate-hashes --annotation-style line --custom-compile-command ./update-requirements.sh "$@"
