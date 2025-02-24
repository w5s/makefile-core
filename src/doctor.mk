# Makefile doctor list of targets
MAKEFILE_DOCTOR_TARGETS :=

# Display a diagnostic of common errors
#
# To add a new check just create a new target (.doctor is a convention)
# .doctor.my-target:
#   //...
#
# MAKEFILE_DOCTOR_TARGETS += .doctor.my-target # Register target
#
# Example : make doctor
#
.PHONY: doctor
doctor: ## Check your system for potential problems.
	@$(call log,info,"[Make] Doctor")
	$(Q)FAILS=0; \
	for target in $(MAKEFILE_DOCTOR_TARGETS); do \
		$(MAKE) $$target || FAILS=1; \
	done; \
	if [ $$FAILS -eq 0 ]; then \
		$(call log,info,"🎉 Everything is OK",1); \
	else \
		$(call log,fatal,"❌ Some problems need to be fixed",1); \
		exit 1; \
	fi


# Default doctor jobs that will check if git modules were initialized
.PHONY: .doctor.git-submodules
.doctor.git-submodules:
	@$(call log,info,"✓ Checking git submodules",1);
	$(Q)if [ ! -f .gitmodules ]; then \
		exit 0; \
	fi
	$(Q)MISSING=$$(grep path .gitmodules | sed 's/.*= //' | xargs -n 1 sh -c 'test ! -d "$$0" && echo $$0'); \
	if [ -n "$$MISSING" ]; then \
		$(call log,error,Some git submodules are not installed,2); \
		$(call log,error,Run 'make self-install to fix.',2); \
		exit 1; \
	fi

MAKEFILE_DOCTOR_TARGETS += .doctor.git-submodules
