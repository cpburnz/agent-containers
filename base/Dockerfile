FROM docker.io/oven/bun:1 AS bun

FROM node:24-slim

ARG HOST_UID=1000
ARG HOST_GID=1000

# Combine all tools here. Note: added specific tools you listed for runtime
ARG LOCAL_TOOLS=""

# 1. Install System Dependencies (as root)
RUN apt-get update && \
	apt-get install -y --no-install-recommends ${LOCAL_TOOLS} && \
	rm -rf /var/lib/apt/lists/*

# Install Bun by copying from the official image
# This installs bun globally to /usr/local/bin so it is available to everyone
COPY --from=bun /usr/local/bin/bun /usr/local/bin/bun
# Create the bunx symlink (standard practice)
RUN ln -s /usr/local/bin/bun /usr/local/bin/bunx

# Corepack
RUN corepack enable

# 2. Configure the existing 'node' user
# The node image usually creates the node user. We ensure it owns the app dir.
WORKDIR /app
RUN chown -R node:node /app

# 3. Switch to 'node' user for config setup
USER node

# 4. Configure NPM global location for the 'node' user
# This allows npm install -g without root permissions
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$NPM_CONFIG_PREFIX/bin:$PATH

# Configure Bun global location for 'node' user ---
# This ensures 'bun install -g' works without root and saves to the user home
ENV BUN_INSTALL=/home/node/.bun
ENV PATH=$BUN_INSTALL/bin:$PATH

RUN mkdir -p /home/node/.npm-global && \
	mkdir -p /home/node/.config && \
	mkdir -p /home/node/.local && \
	mkdir -p /home/node/.bun/bin

# 6. Bash Configuration
# Add the path export to bashrc so interactive shells pick it up
RUN echo "export PATH=${NPM_CONFIG_PREFIX}/bin:${BUN_INSTALL}/bin:\$PATH" >> /home/node/.bashrc

CMD ["/bin/bash"]
