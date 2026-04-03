#
# This Dockerfile creates the OpenCode image.
#

#
# Build stage.
#
FROM node:24-trixie-slim as build
ENV OPENSPEC_NO_COMPLETIONS=1
ENV OPENSPEC_TELEMETRY=0

# Install opencode node packages.
USER node
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
RUN npm install -g opencode-ai @fission-ai/openspec

#
# Runtime stage.
#
FROM localhost/agent-base
USER root
ENV OPENSPEC_TELEMETRY=0

# Install system packages.
RUN apt-get update && \
	apt-get install -y --no-install-recommends ca-certificates curl jq && \
	rm -rf /var/lib/apt/lists/*

# Copy opencode node packages.
COPY --from=build /home/node/.npm-global /usr/local

# Configure NPM.
USER node
ENV NPM_CONFIG_PREFIX=/opt/node
ENV PATH=$NPM_CONFIG_PREFIX/bin:$PATH

# Run opencode.
WORKDIR /app
CMD ["opencode"]
