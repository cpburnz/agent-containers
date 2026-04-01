set unstable

# Get XDG directories.
host_config_home := env('XDG_CONFIG_HOME', '') || home_dir() / '.config'

# Display available recipes.
help:
	@just -l

# Build all images.
all: base debug opencode squid-proxy

# Build base image.
base:
	@echo "Building base image"
	podman build \
		-t agent-base \
		-f base/Dockerfile base

# Build debug image.
debug:
	@echo "Building debug image"
	podman build \
		-t agent-debug \
		-f debug/Dockerfile debug

# Build opencode image.
opencode: base
	@echo "Building opencode"
	podman build \
		--no-cache \
		-t agent-opencode \
		-f opencode/Dockerfile opencode

# Setup podman networks.
setup-podman:
	if ! podman network exists agent-net; then \
		podman network create agent-net; \
	fi
	if ! podman network exists agent-internal-net; then \
		podman network create --internal agent-internal-net; \
	fi

# Create proxy configs if they do not already exist.
setup-proxy-configs:
	mkdir -p {{quote(host_config_home / 'agent-containers/proxy')}}
	if [ ! -f {{quote(host_config_home / 'agent-containers/proxy/access.conf')}} ]; then \
		cp {{quote(justfile_dir() / 'squid-proxy/access.conf')}} {{quote(host_config_home / 'agent-containers/proxy/access.conf')}}; \
	fi
	if [ ! -f {{quote(host_config_home / 'agent-containers/proxy/ports.conf')}} ]; then \
		cp {{quote(justfile_dir() / 'squid-proxy/ports.conf')}} {{quote(host_config_home / 'agent-containers/proxy/ports.conf')}}; \
	fi

# Build squid proxy image.
squid-proxy:
	@echo "Building squid image"
	podman build \
		-t agent-squid-proxy \
		-f squid-proxy/Dockerfile squid-proxy

# Remove container images.
clean:
	@echo "Removing container images"
	@for image in agent-squid-proxy agent-opencode agent-debug agent-base; do \
		if podman image inspect "$image" > /dev/null 2>&1; then \
			echo "Removing $image"; \
			podman rmi -f "$image"; \
		else \
			echo "Image $image does not exist, skipping"; \
		fi; \
	done
