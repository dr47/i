#!/bin/bash
set -euo pipefail

VERSION="0.9.0"
DATE=$(date +%Y%m%d)

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

podman build \
    --tag localhost/nvim:work \
    --file "$SCRIPT_DIR/Containerfile" \
    "$SCRIPT_DIR"

container=$(podman run -d --init localhost/nvim:work sleep infinity)
trap 'podman rm -f "$container" >/dev/null' EXIT

read -p "check :Mason , :checkhealth nvim-treesitter, then exit using :qa, abort :cq. (key)" dummy
podman exec -it --user nvim "$container" nvim

podman exec --user root "$container" sh -ec '
    chown -R root:root /home/nvim
    chmod -R a+rX,go-w /home/nvim
    mkdir -p /home/nvim/.cache
    chown -R nvim:nvim /home/nvim/.cache
'

podman stop "$container"
podman commit "$container" localhost/nvim:$VERSION-$DATE
podman tag localhost/nvim:$VERSION-$DATE localhost/nvim:stable
echo "OK: localhost/nvim:$VERSION-$DATE (stable)"
