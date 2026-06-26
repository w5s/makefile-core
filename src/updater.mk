MAKEFILE_CORE_MODULES_FILE := module.json

## Commit format: gitmoji | conventional
MAKEFILE_CORE_GIT_COMMIT_FORMAT ?= conventional

ifeq ($(MAKEFILE_CORE_GIT_COMMIT_FORMAT),conventional)
.MAKEFILE_CORE_ADD_COMMIT_MESSAGE_PREFIX_DEFAULT := chore(subtree): add
.MAKEFILE_CORE_UPDATE_COMMIT_MESSAGE_PREFIX_DEFAULT := chore(subtree): upgrade
else
.MAKEFILE_CORE_ADD_COMMIT_MESSAGE_PREFIX_DEFAULT := 🔨 Add
.MAKEFILE_CORE_UPDATE_COMMIT_MESSAGE_PREFIX_DEFAULT := 🔨 Upgrade
endif

# Allow users to override prefixes explicitly.
ifeq ($(origin MAKEFILE_CORE_ADD_COMMIT_MESSAGE_PREFIX), undefined)
MAKEFILE_CORE_ADD_COMMIT_MESSAGE_PREFIX := $(.MAKEFILE_CORE_ADD_COMMIT_MESSAGE_PREFIX_DEFAULT)
endif

ifeq ($(origin MAKEFILE_CORE_UPDATE_COMMIT_MESSAGE_PREFIX), undefined)
MAKEFILE_CORE_UPDATE_COMMIT_MESSAGE_PREFIX := $(.MAKEFILE_CORE_UPDATE_COMMIT_MESSAGE_PREFIX_DEFAULT)
endif

.self_add_module=$(or $(name), $(notdir $(url)), '')

# Returns a list of all module names from the modules.json file.
#
# Usage:
#   make self-list
#
.PHONY: self-list
self-list: ## List all installed modules (in module.json)
	$(Q)if [ ! -f "$(MAKEFILE_CORE_MODULES_FILE)" ]; then \
		$(call panic,$(MAKEFILE_CORE_MODULES_FILE) does not exist. Try make self-add to add modules.); \
	fi
	$(Q)$(JQ) -r 'keys[]' $(MAKEFILE_CORE_MODULES_FILE)

# Returns a list of all module names from the modules.json file.
#
# Usage:
#   make self-add name=<string> url=<git-repository>
#
# Example:
#   make self-add name=makefile-ci url=https://github.com/w5s/makefile-ci
#
.PHONY: self-add
self-add: $(MODULES_PATH) ## url=<git-repository> [name=<string>] Install a module in .modules/ (using git subtree)
	$(Q)if [ -z "$(.self_add_module)" ] || [ -z "$(url)" ]; then \
		$(call panic,Usage: make self-add name=<string> url=<git-repository>); \
	fi
# Create folder
	$(Q)$(MKDIRP) $(MODULES_PATH)
# Check if module is already present
	$(Q)if $(JQ) -e '.["$(.self_add_module)"]' $(MAKEFILE_CORE_MODULES_FILE) &>/dev/null; then \
		$(call panic,$(.self_add_module) already present in $(MAKEFILE_CORE_MODULES_FILE)); \
	elif [ -d "$(MODULES_PATH)/$(.self_add_module)" ]; then \
		$(call panic,$(MODULES_PATH)/$(.self_add_module) should be empty); \
	fi

# Linking repository
	@$(call log,info,[Make] Adding subtree: $(.self_add_module) from $(url),0);
	$(Q)$(GIT) subtree add --prefix=$(MODULES_PATH)/$(.self_add_module) $(url) main \
		--squash \
		--message "$(MAKEFILE_CORE_ADD_COMMIT_MESSAGE_PREFIX) $(.self_add_module)";
# git commit -m "chore(subtree): add $(name) from $(repo)";

# Create empty file if it does not exist
	$(Q)if [ ! -f "$(MAKEFILE_CORE_MODULES_FILE)" ]; then \
		echo "{}" > $(MAKEFILE_CORE_MODULES_FILE); \
	fi

# Edit module.json file
	$(Q)echo "Adding $(.self_add_module) to $(MAKEFILE_CORE_MODULES_FILE)";
	$(Q)$(JQ) \
		'.["$(.self_add_module)"] = "$(url)"' \
		$(MAKEFILE_CORE_MODULES_FILE) > $(MAKEFILE_CORE_MODULES_FILE).tmp \
	&& mv $(MAKEFILE_CORE_MODULES_FILE).tmp $(MAKEFILE_CORE_MODULES_FILE) \
	&& git add $(MAKEFILE_CORE_MODULES_FILE) \
	&& git commit --amend --no-edit


# This target will
# 1. Update makefile/core.mk
# 2. Update all submodules
#
# Example : make self-update
#
.PHONY: self-update
self-update: ## Update all modules (in .modules/)
# Update core
	$(Q)$(MAKE) -f $(firstword $(MAKEFILE_LIST)) self-update.core
# Update modules
	$(Q)$(MAKE) -f $(firstword $(MAKEFILE_LIST)) self-update.modules

# Target for makefile core
.PHONY: self-update.core
self-update.core:
	@$(call log,info,[Make] Updating $(MAKEFILE_CORE) from git...,0)
# Download file using curl
	$(Q)-$(CURL) -sSfL "$(MAKEFILE_CORE_URL)" --output "$(MAKEFILE_CORE)"
# Update index (if file was not changed, we do not care about file time modification)
	$(Q)-$(GIT) update-index --refresh $(MAKEFILE_CORE) || true
# Commit changes if needed
	$(Q)$(GIT) diff --quiet HEAD -- $(MAKEFILE_CORE) \
		|| $(GIT) commit -m "$(MAKEFILE_CORE_UPDATE_COMMIT_MESSAGE_PREFIX) makefile-core" $(MAKEFILE_CORE)

# Target for makefile modules
.PHONY: self-update.modules
self-update.modules:
	@$(call log,info,[Make] Updating $(MODULES_PATH)/* ...,0)

ifeq ($(wildcard $(MAKEFILE_CORE_MODULES_FILE)),)
# No module.json found
	@$(call log,warn,[Make] Update skipped (no module.json found),0)
else
# module.json found
	$(Q)$(JQ) -r 'to_entries[] | "\(.key) \(.value)"' $(MAKEFILE_CORE_MODULES_FILE) | while read name repo; do \
		$(call log,info,>> $$name,1); \
		git subtree pull --prefix=$(MODULES_PATH)/$$name $$repo main \
			--squash \
			--message "$(MAKEFILE_CORE_UPDATE_COMMIT_MESSAGE_PREFIX) $$name"; \
	done
	@$(call log,info,[Make] Update finished,0)
endif
