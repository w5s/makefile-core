# Return a newline character
#
# Example:
#   $(newline)
define newline


endef

# Escape a shell string passed as a single quoted string
#
# Usage:
# 	$(call escape-shell,<string>)
#
# Example:
#  embeddable-text = $(call escape-shell,$(SOME_TEXT))
#
escape-shell = $(subst $(newline),\$(newline),$(subst ','\'',$(1)))

# Lower-case a string value.
#
# Usage:
# 	$(call lowercase,<string>)
#
# Example:
# 	$(call lowercase,HeLlO wOrLd) # "hello world"
lowercase = $(shell echo $(call escape-shell,$(1)) | tr '[:upper:]' '[:lower:]')

# Upper-case a string value.
#
# Usage:
# 	$(call uppercase,<string>)
#
# Example:
# 	$(call uppercase,HeLlO wOrLd) # "HELLO WORLD"
uppercase = $(shell echo $(call escape-shell,$(1)) | tr '[:lower:]' '[:upper:]')

# Slugify a string value.
#
# Usage:
# 	$(call slugify,<string>)
#
# Example:
# 	$(call slugify,HeLlO wOrLd) # "hello-world"
slugify = $(shell echo $(call escape-shell,$(1)) | tr '[:upper:]' '[:lower:]' | tr '[:punct:]' '-' | tr ' ' '-' )

# Determine the "truthiness" of a value.
#
# A value is considered to be falsy if it is:
#
#   - empty, or
#   - equal to "0", "N", "NO", "F" or "FALSE" after upper-casing.
#
# If the value is truthy then the value is returned as-is, otherwise no value
# is returned.
#
# Usage:
# 	$(call filter-false,<string>)
#
# Example:
#
#     truthy := y
#     truthy-flag := $(call filter-false,$(truthy)) # "y"
#
#     falsy := n
#     falsy-flag := $(call filter-false,$(falsy)) # <empty>
#
#     ifneq ($(call filter-false,$(FLAG_ENABLED)),)
#       // will executed only when FLAG_ENABLED is truthy
#     endif
#
filter-false = $(filter-out 0 n no f false,$(call lowercase,$(1)))

# Returns the first command found
#
#	Usage:
# 	$(call resolve-command,<cmd1> <cmd2> ...)
#
# Example:
# 	NODE_VERSION_MANAGER := $(call resolve-command,asdf nodenv nvm)
#
define resolve-command
$(firstword $(foreach cmd,$(1),$(shell which $(cmd) &>/dev/null && echo $(cmd))))
endef
