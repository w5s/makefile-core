#!/usr/bin/env bash

# Stop when errors
set -euo pipefail

MAKEFILES_PREFIX=".modules"
MAKEFILECORE_FILE="$MAKEFILES_PREFIX/core.mk"
MAKEFILE_CORE_URL=https://raw.githubusercontent.com/w5s/makefile-core/main/core.mk
INCLUDE_TEMPLATE="include $MAKEFILECORE_FILE"

# Download core module
mkdir -p $MAKEFILES_PREFIX
curl -fsSL -o "$MAKEFILECORE_FILE" "$MAKEFILE_CORE_URL"

# Update Makefile
touch Makefile

if ! grep "$INCLUDE_TEMPLATE" Makefile > /dev/null; then
  MAKEFILE_CONTENT=$(cat Makefile)
  cat << EOF > Makefile
# Include Core
# The following files will be included before
# 1. Makefile.local (⚠️ This file should never be versioned)
# 2. Makefile.config
# 3. .modules/core.mk (default values)
# 4. .modules/*/module.mk
$INCLUDE_TEMPLATE
$MAKEFILE_CONTENT
EOF

fi

if [[ ! -f Makefile.config ]]; then
  cat << EOF > Makefile.config
# Makefile configuration

# Upstream for core.mk used by make self-update
export MAKEFILE_CORE_URL := $MAKEFILE_CORE_URL

# Project name (ex: vesta)
# export CI_PROJECT_NAME ?= <TODO>

# Project namespace (ex: w5s)
# export CI_PROJECT_NAMESPACE ?= <TODO>
EOF

fi
