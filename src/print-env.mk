# Variables that are defined in makefile
define .VARIABLES_ENV
$(foreach V,$(.VARIABLES), \
	$(if $(filter-out environment% default automatic, $(origin $V)), $V) \
)
endef

# Not portable variables
.VARIABLES_INTERNAL_HIDDEN := PWD SHELL MAKEFLAGS MAKE_PID MAKE_PPID

.PHONY: env
print-env: .before_each ## Display all env variables exported by make
	@env | \
		grep -E "^($(shell echo $(CI_VARIABLES) $(filter-out $(.VARIABLES_INTERNAL_HIDDEN),$(.VARIABLES_ENV)) | tr ' ' '|'))=" | \
		sort -f
