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
# 1. Makefile.local.mk (⚠️ This file should never be versioned)
# 2. Makefile.config.mk
# 3. .modules/core.mk (default values)
# 4. .modules/*/module.mk
$INCLUDE_TEMPLATE
$MAKEFILE_CONTENT
EOF

fi

if [[ ! -f Makefile.config.mk ]]; then
  cat << EOF > Makefile.config.mk
# Makefile configuration

# Upstream for core.mk used by make self-update
export MAKEFILE_CORE_URL := $MAKEFILE_CORE_URL

# git commit format
export MAKEFILE_CORE_GIT_COMMIT_FORMAT := conventional

# Uncomment this to override
# MAKEFILE_CORE_ADD_COMMIT_MESSAGE_PREFIX ?= 🔨 Add
# MAKEFILE_CORE_UPDATE_COMMIT_MESSAGE_PREFIX ?= 🔨 Upgrade

# Project name (ex: my-repository)
# export CI_PROJECT_NAME ?= <TODO>

# Project namespace (ex: my-organization)
# export CI_PROJECT_NAMESPACE ?= <TODO>
EOF

fi
