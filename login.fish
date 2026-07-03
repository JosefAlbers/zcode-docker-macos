#!/usr/bin/env fish

set -l cid (podman ps -q)
if test -z "$cid"
    echo "No running container found. Start one with ./run.fish first."
    exit 1
end

echo "Waiting for ZCode to request login (waiting on /OAUTH_URL.txt)..."
set -l url ""
while test -z "$url"
    set url (podman exec $cid cat /OAUTH_URL.txt 2>/dev/null)
    sleep 1
end

open "$url"

echo ""
echo "Log in → right-click → Inspect → Console → Copy URL"
echo ""
read -P "Paste the zcode://zai-auth/callback... URL here: " callback_url

if test -z "$callback_url"
    echo "No URL entered, aborting."
    exit 1
end

podman exec -it $cid bash -c "source /root/.dbus-env && /opt/ZCode/zcode --no-sandbox '$callback_url'"

