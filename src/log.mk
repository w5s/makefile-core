
# Externally define log levels
LOG_DEBUG := 0
LOG_INFO := 1
LOG_WARN := 2
LOG_ERROR := 3
LOG_FATAL := 4

## Set the log level (debug/info/warn/error/fatal default:info)
LOG_LEVEL ?= info
export LOG_LEVEL

# Define some commonly used values in log strings
LOG_HEADER_DEBUG := -d-
LOG_HEADER_INFO := =i=
LOG_HEADER_WARN := =!=
LOG_HEADER_ERROR := =!=
LOG_HEADER_FATAL := !!!

# Defined in makefile-core
LOG_COLOR_DEBUG := $(PURPLE)
LOG_COLOR_INFO := $(BLUE)
LOG_COLOR_WARN := $(YELLOW)
LOG_COLOR_ERROR := $(RED)
LOG_COLOR_FATAL := $(RED)

#define some useful macros
__log_to_upper = $(shell echo $(1) | tr '[:lower:]' '[:upper:]')
# __log_to_lower = $(shell echo $(1) | tr '[:upper:]' '[:lower:]')

# Define the logging macros

define __log_generic
([ $(LOG_$(call __log_to_upper,$(LOG_LEVEL))) -gt $(2) ] || echo "$(log_bold)$(3)$(4) $(5)$(1)$(RESET)")
endef

# Log a message to console
#
# Usage:
#   $(call log,<level>,<message>,<indent_level>)
#
# Example:
# 	@$(call log,info,"[MyCategory] Install something...",0)
# 	@$(call log,info,"[MyCategory] Sub command with indent...",1)
#
define log
$(call __log_generic,$(2),$(LOG_$(call __log_to_upper,$(1))),$(LOG_COLOR_$(call __log_to_upper,$(1))),$(LOG_HEADER_$(call __log_to_upper,$(1))),$(shell [ "$(or $(3),0)" = 0 ] || for i in $(shell seq 1 $(or $(3),0)); do echo -n '  '; done))
endef

# Log a message with fatal level and exit program
#
# Usage:
#   $(call panic,<message>)
# Example:
# 	$(call panic,Something wrong happened !)
#
define panic
	$(call log,fatal,$(1));exit 1
endef
