#!/usr/bin/env bash
set -e

# Return to the app working directory
cd /app

# Execute the main command (opencode, claude login, /bin/bash, etc.)
exec "$@"
