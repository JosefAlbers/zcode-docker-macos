#!/usr/bin/env bash
#   ./run.sh            # build image if needed, then run
#   ./run.sh --rebuild   # force rebuild the image first

set -euo pipefail

IMAGE=ubuntu-zcode

if [[ "${1:-}" == "--rebuild" ]]; then
    podman build -t "$IMAGE" .
elif ! podman image exists "$IMAGE"; then
    echo "Image '$IMAGE' not found, building..."
    podman build -t "$IMAGE" .
fi

podman rm -f "$(podman ps -aq)" 2>/dev/null || true

export DISPLAY=:0
/opt/X11/bin/xhost +

echo "Starting container. In here, run: zcode --no-sandbox"
echo "Then in a second terminal, run: ./login.sh"
echo ""

podman run -it --rm -e DISPLAY=host.containers.internal:0 "$IMAGE" bash
