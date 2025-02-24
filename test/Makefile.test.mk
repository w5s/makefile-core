include ../core.mk

## test=true Test Flag Root
TEST_FLAG_ROOT ?= test-flag-root
export TEST_FLAG_ROOT

TEST_FLAG_ROOT_NO_HELP ?=

test-root: ## test=true Test included root

test-root-no-help:

.PHONY: $(filter stub-%,$(MAKECMDGOALS)))

stub-verbose:
	$(Q)echo verbose!

stub-lowercase:
	$(Q)echo $(call lowercase,$(input))

stub-uppercase:
	$(Q)echo $(call uppercase,$(input))

stub-slugify:
	$(Q)echo $(call slugify,$(input))

stub-log:
	$(Q)$(call log,$(level),$(message),1)

stub-filter-false:
	$(Q)echo $(call filter-false,$(input))

stub-resolve-command:
	$(Q)echo $(call resolve-command,$(input))

.PHONY: stub-core-hooks $(call core-hooks,.stub-core-hooks)
stub-core-hooks: $(call core-hooks,.stub-core-hooks)
	$(Q):

.stub-core-hooks.before::
	$(Q)echo Before stub-core-hooks !
.stub-core-hooks:
	$(Q)echo Run stub-core-hooks !
.stub-core-hooks.after::
	$(Q)echo Before stub-core-hooks !
