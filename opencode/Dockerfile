#
# This Dockerfile creates the OpenCode image.
#

#
# Build stage.
#
FROM node:24-trixie-slim as build
USER node
WORKDIR /build

# Download opencode (latest version).
RUN npm install opencode-linux-x64 --ignore-scripts && \
	echo "Installed OpenCode version: $(node_modules/opencode-linux-x64/bin/opencode --version)"

#
# Runtime stage.
#
FROM localhost/agent-base

# Install runtime-time packages.
RUN apt-get update && \
	apt-get install -y --no-install-recommends curl && \
	rm -rf /var/lib/apt/lists/*

# Copy opencode.
COPY --from=build --chmod=755 /build/node_modules/opencode-linux-x64/bin/opencode /usr/bin/opencode

# Run opencode.
USER node
WORKDIR /app
ENTRYPOINT ["opencode"]
