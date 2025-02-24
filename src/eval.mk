
# Evaluate a given command in the make environment.
#
# Usage:
#   make eval command=<string>
# Example:
#
.PHONY: eval $(call core-hooks,.eval)
eval: $(call core-hooks,.eval) ## command=<string> Evaluate command in make environment

# Eval implementation
.eval:
	$(Q)$(command)
