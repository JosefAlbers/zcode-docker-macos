#!/usr/bin/env fish
#   ./run.fish            # build image if needed, then run
#   ./run.fish --rebuild   # force rebuild the image first

set -l IMAGE ubuntu-zcode

if contains -- --rebuild $argv
    podman build -t $IMAGE .
else if not podman image exists $IMAGE
    echo "Image '$IMAGE' not found, building..."
    podman build -t $IMAGE .
end

podman rm -f (podman ps -aq) 2>/dev/null; or true

set -gx DISPLAY :0
/opt/X11/bin/xhost +

echo "Starting container. In here, run: zcode --no-sandbox"
echo "Then in a second terminal, run: ./login.fish"
echo ""

podman run -it --rm -e DISPLAY=host.containers.internal:0 $IMAGE bash
