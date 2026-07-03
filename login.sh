#!/usr/bin/env bash

set -euo pipefail

cid=$(podman ps -q)
if [[ -z "$cid" ]]; then
    echo "No running container found. Start one with ./run.sh first."
    exit 1
fi

echo "Waiting for ZCode to request login (waiting on /OAUTH_URL.txt)..."
url=""
while [[ -z "$url" ]]; do
    url=$(podman exec "$cid" cat /OAUTH_URL.txt 2>/dev/null || true)
    [[ -z "$url" ]] && sleep 1
done

open "$url"

echo ""
echo "Log in → right-click → Inspect → Console → Copy URL"
echo ""
read -r -p "Paste the zcode://zai-auth/callback... URL here: " callback_url

if [[ -z "$callback_url" ]]; then
    echo "No URL entered, aborting."
    exit 1
fi

podman exec -it "$cid" bash -c "source /root/.dbus-env && /opt/ZCode/zcode --no-sandbox '$callback_url'"

