#!/bin/bash
set -euo pipefail

VERSION="0.5"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

podman build \
    --tag localhost/nvim:base \
    --file "$SCRIPT_DIR/Containerfile" \
    "$SCRIPT_DIR"

container=$(podman run -d --init localhost/nvim:base sleep infinity)
trap 'podman rm -f "$container" >/dev/null' EXIT

read -p "check :Mason , :checkhealth nvim-treesitter, then exit using :qa, abort :cq. (key)" dummy
podman exec -it --user nvim "$container" nvim

podman exec --user root "$container" sh -ec '
    chown -R root:root /home/nvim
    chmod -R a+rX,go-w /home/nvim
    mkdir -p /home/nvim/.cache
    chown -R nvim:nvim /home/nvim/.cache
'

podman kill "$container" >/dev/null
podman commit --change 'CMD ["nvim"]' "$container" localhost/nvim:dev
