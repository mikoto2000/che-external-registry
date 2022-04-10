# che-external-registry-buildkit

## Build:

```sh
docker build -t mikoto2000/che-external-registry-buildkit:latest .
```

## Usage:

```sh
docker run -it --rm --name cer -v "$(pwd):/work" --workdir /work -v "$HOME/.m2:/root/.m2" -v "/var/run/docker.sock:/var/run/docker.sock" -p "8080:8080" mikoto2000/che-external-registry-buildkit:latest
```
