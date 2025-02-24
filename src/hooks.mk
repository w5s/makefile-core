
# Returns a list of target from $(1)
#
# 	-> 1. Run .before_each
# 	-> 2. Run $(1).before
# 	-> 3. Run $(1)
# 	-> 4. Run $(1).after
# 	-> 5. Run .after_each
#
#	Usage:
# 	$(call core-hooks,<target>)
#
# Example:
# 	.PHONY: my-target $(call core-hooks,.my-target)
# 	my-target: $(call core-hooks,.my-target)
#  	.my-target.before::
#  		@echo Before my-target !
#  	.my-target:
#  		@echo Run my-target !
#  	.my-target.after::
#  		@echo After my-target !
#
define core-hooks
	.before_each $(1).before $(1) $(1).after .after_each
endef

# Global hook that should be run before each target
#
# Example:
# .before_each::
# 	@echo Before each !
#
.before_each::
	@$(call log,debug,[Make] .before_each hook,0)

# Global hook that should be run after each target
#
# Example:
# .after_each::
# 	@echo After each !
#
.after_each::
	@$(call log,debug,[Make] .after_each hook,0)
