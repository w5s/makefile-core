## Common Makefile extensions resolved for optional overrides (bare name is always tried)
MAKEFILE_EXTENSIONS ?= .mk .make

# Candidates for a stem: Makefile.local Makefile.local.mk Makefile.local.make
makefile-candidates = $(1) $(addprefix $(1),$(MAKEFILE_EXTENSIONS))

# Optional versioned Makefile(s) that override defaults (override the whole list to bypass extension logic)
MAKEFILE_CONFIG := $(call makefile-candidates,Makefile.config)
# Optional unversioned Makefile(s) that override defaults (override the whole list to bypass extension logic)
MAKEFILE_LOCAL := $(call makefile-candidates,Makefile.local)

# Include config first, then local (local overrides config)
-include $(wildcard $(MAKEFILE_CONFIG))
-include $(wildcard $(MAKEFILE_LOCAL))
