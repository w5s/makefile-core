.PHONY: build
build:
	@ script/build
# Update core.mk used by tests
	@ cp core.mk test/.modules/

.PHONY: test
test: build
	@ script/test

.PHONY: test-update
test-update: build
	@ UPDATE_SNAPSHOT=1 script/test
