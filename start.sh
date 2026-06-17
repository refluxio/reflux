#!/bin/bash
set -e

GHCR_IMAGE="ghcr.io/refluxio/reflux:latest"
MIRROR_IMAGE="${REFLUX_MIRROR:-registry.cn-hangzhou.aliyuncs.com/refluxio/reflux:latest}"

echo "Trying GHCR: $GHCR_IMAGE"
if docker pull "$GHCR_IMAGE" 2>/dev/null; then
  export REFLUX_IMAGE="$GHCR_IMAGE"
  echo "Using GHCR image"
else
  echo "GHCR unavailable, falling back to mirror: $MIRROR_IMAGE"
  docker pull "$MIRROR_IMAGE"
  export REFLUX_IMAGE="$MIRROR_IMAGE"
  echo "Using mirror image"
fi

docker compose up -d
