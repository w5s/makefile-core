#
# Includes every makefiles configured by MAKEFILE_INCLUDE excluding MAKEFILE_EXCLUDE
#
include $(filter-out $(MAKEFILE_EXCLUDE),$(MAKEFILE_INCLUDE))
