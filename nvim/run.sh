#!/bin/bash

set -euo pipefail

VERSION="0.10"

CLAUDE="$HOME/.claude.key"

fail() {
    printf 'run.sh: %s\n' "$*" >&2
    exit 1
}

# Claude
[[ -f "$CLAUDE" && -r "$CLAUDE" ]] || fail "Chybí čitelný soubor: $CLAUDE"
ANTHROPIC_API_KEY=$(sed -n 's/^ANTHROPIC_API_KEY=//p' "$CLAUDE" | tail -n1 | tr -d "\"'")
[[ -n "${ANTHROPIC_API_KEY:-}" ]] || fail "V ~/.claude.key chybí neprázdný ANTHROPIC_API_KEY"
export ANTHROPIC_API_KEY


STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/nvim-container"
mkdir -p -- "$STATE_DIR"
chmod 0700 -- "$STATE_DIR"

SESSIONS_DIR="$STATE_DIR/codecompanion/sessions"
mkdir -p -- "$SESSIONS_DIR"

mounts=()
paths=()
cwd=/
declare -A seen=()

for arg in "$@"; do
    path=$(realpath -e -- "$arg") || fail "Neexistující cesta: $arg"
    [[ -f "$path" || -d "$path" ]] || fail "Není soubor ani adresář: $path"
    [[ "$path" != / && "$path" != *,* ]] || fail "Nepodporovaná cesta: $path"

    for protected in /etc /usr /bin /sbin /lib /lib64 /proc /sys /dev /run /root /var /opt /home/nvim; do
        if [[ "$path" == "$protected" || "$path" == "$protected/"* || "$protected" == "$path/"* ]]; then
            fail "Mount by překryl chráněnou cestu: $path"
        fi
    done

    if ((${#paths[@]} == 0)); then
        if [[ -d "$path" ]]; then
            cwd=$path
        else
            cwd=$(dirname -- "$path")
        fi
    fi

    if [[ -z "${seen[$path]+present}" ]]; then
        mounts+=(--mount "type=bind,src=$path,dst=$path")
        seen["$path"]=1
    fi
    paths+=("$path")
done



exec podman run --rm -it --name nvim --hostname nvim \
    --userns=keep-id:uid=1000,gid=1000 \
    --env ANTHROPIC_API_KEY \
    --tmpfs /home/nvim/.cache:rw,nosuid,nodev,noexec,U,mode=0700,size=256m \
    --mount "type=bind,src=$STATE_DIR,dst=/home/nvim/.local/state/nvim" \
    --mount "type=bind,src=$SESSIONS_DIR,dst=/home/nvim/.local/share/nvim/codecompanion/sessions" \
    "${mounts[@]}" \
    --workdir "$cwd" \
    localhost/nvim:stable \
    nvim --cmd 'set backupcopy=yes nobackup nowritebackup' -- "${paths[@]}"
