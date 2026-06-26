## Optional Makefile versioned that override any value (default "Makefile.config.mk")
MAKEFILE_CONFIG ?= Makefile.config.mk
## Optional Makefile unversioned that override any value (default "Makefile.local.mk")
MAKEFILE_LOCAL ?= Makefile.local.mk

# Include Makefile.local if it exists
-include $(wildcard $(MAKEFILE_LOCAL:.mk=) $(MAKEFILE_LOCAL) $(MAKEFILE_LOCAL:.mk=).*)

# Include Makefile.config if it exists
-include $(wildcard $(MAKEFILE_CONFIG:.mk=) $(MAKEFILE_CONFIG) $(MAKEFILE_CONFIG:.mk=).*)
