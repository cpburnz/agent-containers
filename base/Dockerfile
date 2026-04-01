#
# This Dockerfile creates the base agent image.
#
# NOTICE: The hardened images such as "dhi.io/node:24" are too cumbersome to
# work with. There's no easy solution to install packages, and then harden.
# OpenCode gave strange errors about needing "tar" to run its glob and grep
# tools.
#

#
# Build stage.
#
#FROM node:24-trixie-slim

# Nothing to do.

#
# Runtime stage.
#
FROM node:24-trixie-slim

# Setup node user directories.
RUN install -o node -g node -d /app && \
	install -o node -g node -d /home/node/.config && \
	install -o node -g node -d /home/node/.local
