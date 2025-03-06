# Variables that are defined in makefile
.VARIABLES_ENV = $(foreach V,$(.VARIABLES),$(if $(filter-out environment% default automatic,$(origin $V)),$V))

# Not portable variables
.VARIABLES_INTERNAL_HIDDEN := PWD SHELL MAKEFLAGS MAKE_PID MAKE_PPID

# This target will print every exported variables declared
#
# Example : make print-env
#
.PHONY: env
print-env: .before_each ## Display all env variables exported by make
	@env | \
		grep -E "^($(shell echo $(CI_VARIABLES) $(filter-out $(.VARIABLES_INTERNAL_HIDDEN),$(.VARIABLES_ENV)) | tr ' ' '|'))=" | \
		sort -f
