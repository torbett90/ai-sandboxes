#!/usr/bin/env bash
set -e

HOST_HOME="/host_home"
SANDBOX_HOME="/home/sandbox"
OC_SANDBOX_DIR="${HOST_HOME}/.oc-sandbox"
OC_CONFIG_DIR="${SANDBOX_HOME}/.config/opencode"

# Ensure both config and local state/log directories exist and are writable
mkdir -p "${OC_CONFIG_DIR}" "${SANDBOX_HOME}/.local/share/opencode/log"

# 1. Copy global opencode.json and cli.json from ~/.oc-sandbox into ~/.config/opencode
for cfg in opencode.json opencode.jsonc cli.json AGENTS.md; do
    if [ -f "${OC_SANDBOX_DIR}/${cfg}" ]; then
        cp -f "${OC_SANDBOX_DIR}/${cfg}" "${OC_CONFIG_DIR}/${cfg}"
    fi
done

# 2. Symlink OpenCode subdirectories (skills, agents, commands, hooks, plugins)
for subdir in skills agents commands hooks plugins; do
    if [ -d "${OC_SANDBOX_DIR}/${subdir}" ]; then
        rm -rf "${OC_CONFIG_DIR:?}/${subdir:?}"
        ln -s "${OC_SANDBOX_DIR}/${subdir}" "${OC_CONFIG_DIR}/${subdir}"
    fi
done

# 3. Call the universal base init script (which symlinks dotfiles from config)
exec /usr/local/bin/sandbox-init.sh "$@"
