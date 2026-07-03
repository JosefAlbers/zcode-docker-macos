# zcode-docker-macos

Run [ZCode](https://zcode.z.ai) inside a Podman container on macOS, with the window forwarded to your Mac desktop via XQuartz, and OAuth login (Z.ai coding plan) working end to end.

## Prereqs

### Podman

```fish
brew install podman
podman machine init
podman machine start
```

### XQuartz

```fish
brew install --cask xquartz
```

1. Cmd-space open XQuartz → Settings → Security
2. Check **"Allow connections from network clients"**
3. Restart XQuartz

## Quick start

### Terminal 1: build and start the container
```fish
git clone https://github.com/JosefAlbers/zcode-docker-macos
cd zcode-docker-macos
chmod +x *.fish

./run.fish # or ./run.sh
```

### Inside the container
```bash
zcode --no-sandbox
```

### Terminal 2: after clicking login button
```fish
./login.fish # or ./login.sh
```

## Troubleshooting

```fish
podman rm -f (podman ps -aq)
podman build -t ubuntu-zcode . --no-cache
./run.fish
```
