## Optional Makefile loaded to override locally any value (default "Makefile.local")
MAKEFILE_LOCAL ?= Makefile.local

# Include Makefile.local if it exists
#
# /!\ WARNING : this must be at the first file to include so it can setup default values
-include $(MAKEFILE_LOCAL)
