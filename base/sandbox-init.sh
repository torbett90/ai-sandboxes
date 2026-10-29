#!/usr/bin/env bash
set -e

HOST_HOME="/host_home"
SANDBOX_HOME="/home/sandbox"
SANDBOX_CTRL_DIR="${HOST_HOME}/${SANDBOX_DIR_NAME:-.oc-sandbox}"

# Process SYMLINK_FILES and SYNC_FILES from the host sandbox config
if [ -f "${SANDBOX_CTRL_DIR}/config" ]; then
    # shellcheck disable=SC1091
    source "${SANDBOX_CTRL_DIR}/config"

    # Symlink specified files/folders from read-only /host_home into /home/sandbox
    for item in "${SYMLINK_FILES[@]}"; do
        src="${HOST_HOME}/${item}"
        dest="${SANDBOX_HOME}/${item}"
        if [ -e "${src}" ]; then
            mkdir -p "$(dirname "${dest}")"
            rm -rf "${dest}"
            ln -s "${src}" "${dest}"
        fi
    done

    # Copy specified files/folders into /home/sandbox
    for item in "${SYNC_FILES[@]}"; do
        src="${HOST_HOME}/${item}"
        dest="${SANDBOX_HOME}/${item}"
        if [ -e "${src}" ]; then
            mkdir -p "$(dirname "${dest}")"
            cp -rf "${src}" "${dest}"
        fi
    done
fi

# Hand off to the harness-specific command
exec "$@"
