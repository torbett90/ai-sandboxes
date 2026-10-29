# AI Harness Sandboxes (UBI9 Image Factory)

Rootless Podman OCI sandboxes built on **Red Hat Universal Base Image 9 (`ubi9/ubi`)** for running AI coding agents (starting with OpenCode) in strict isolation.

## Architecture
- **`base/`**: Shared Red Hat UBI9 base layer with `git`, `nodejs:20`, `python3`, `ripgrep`, `fd`, unprivileged `sandbox` user (`UID 1000`), and `sandbox-init.sh`.
- **`harnesses/<name>/`**: Modular AI harness definitions automatically built, tested, and published to GHCR by `.github/workflows/image-factory.yml`.
- **`bin/oc-sandbox`**: Host launcher that mounts `$HOME` read-only (`/host_home:ro`), mounts only the active repository (`/workspace:rw`) and `~/.oc-sandbox` (`:rw`), and enforces `--read-only` rootfs with `--cap-drop=ALL`.
