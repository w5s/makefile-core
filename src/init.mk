## Optional Makefile versioned that override any value (default "Makefile.config")
MAKEFILE_CONFIG ?= Makefile.config
## Optional Makefile unversioned that override any value (default "Makefile.local")
MAKEFILE_LOCAL ?= Makefile.local

# Include Makefile.local if it exists
-include $(MAKEFILE_LOCAL)

# Include Makefile.config if it exists
-include $(MAKEFILE_CONFIG)
