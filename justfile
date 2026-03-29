set unstable

# Display available recipes.
help:
	@just -l

# UID/GID
host_uid := shell('id -u')
host_gid := shell('id -g')

# Build all images.
all: base open-code

# Build base image.
base:
	@echo "Building base image"
	podman build \
		-t agent-base \
		-f base/Dockerfile base

# Build open-code image.
open-code: base
	@echo "Building open-code"
	podman build \
		--no-cache \
		-t open-code \
		-f open-code/Dockerfile open-code

# Remove container images.
clean:
	@echo "Removing container images"
	@for image in open-code agent-base; do \
		if podman image inspect "$image" > /dev/null 2>&1; then \
			echo "Removing $image"; \
			podman rmi -f "$image"; \
		else \
			echo "Image $image does not exist, skipping"; \
		fi; \
	done
