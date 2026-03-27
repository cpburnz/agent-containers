set unstable

# Display available recipes.
help:
	@just -l

# Determine container engine (podman or docker)
container_engine := which('podman') || require('docker')

# UID/GID
host_uid := shell('id -u')
host_gid := shell('id -g')

# Tools to install in to the containers with apt-get
local_tools := "ca-certificates curl jq"

# Build all images.
all: base open-code

# Build base image.
base:
	@echo "Building base image"
	{{container_engine}} build \
		--build-arg HOST_UID={{host_uid}} \
		--build-arg HOST_GID={{host_gid}} \
		--build-arg LOCAL_TOOLS={{quote(local_tools)}} \
		-t agent-base \
		-f base/Dockerfile base

# Build open-code image.
open-code: base
	@echo "Building open-code"
	{{container_engine}} build \
		--no-cache \
		-t open-code \
		-f open-code/Dockerfile open-code

# Remove container images.
clean:
	@echo "Removing container images"
	@for image in open-code agent-base; do \
		if {{container_engine}} image inspect "$image" > /dev/null 2>&1; then \
			echo "Removing $image"; \
			{{container_engine}} rmi -f "$image"; \
		else \
			echo "Image $image does not exist, skipping"; \
		fi; \
	done
