MAKE_TEST="make --makefile Makefile.test.mk --no-print-directory"
_TERM=$TERM

export SHELL=${SHELL:-/bin/bash}

unset TERM;
assert "$MAKE_TEST test-included" 'test-included-done'

# FIXME:
# assert_snapshot "$MAKE_TEST print-variables" "make_print-variables.out"
assert_snapshot "$MAKE_TEST help" "make_help.out"
assert_snapshot "$MAKE_TEST" "make_default_help.out"

assert "$MAKE_TEST print-BUNDLE" "bundle"

# VERBOSE flag
assert "$MAKE_TEST stub-verbose" "verbose!"
assert "$MAKE_TEST VERBOSE=true stub-verbose" "echo verbose!\nverbose!"

# lowercase
assert "$MAKE_TEST stub-lowercase input='HeLlO wOrLd'" "hello world"
# uppercase
assert "$MAKE_TEST stub-uppercase input='HeLlO wOrLd'" "HELLO WORLD"
# slugify
assert "$MAKE_TEST stub-slugify input='This is a title_blah!'" "this-is-a-title-blah-"
# log
assert "$MAKE_TEST stub-log level=warn message='Hello world!'" "=!=   Hello world!"
assert "$MAKE_TEST stub-log level=info message='Hello world!'" "=i=   Hello world!"
# filter-false
assert "$MAKE_TEST stub-filter-false input=false" ""
assert "$MAKE_TEST stub-filter-false input=true" "true"

assert "$MAKE_TEST stub-filter-false input=0" ""
assert "$MAKE_TEST stub-filter-false input=1" "1"

assert "$MAKE_TEST stub-filter-false input=no" ""
assert "$MAKE_TEST stub-filter-false input=yes" "yes"

assert "$MAKE_TEST stub-filter-false input=" ""
assert "$MAKE_TEST stub-filter-false input=foo" "foo"
# resolve command
assert "$MAKE_TEST stub-resolve-command input='not-existing make'" "make"
assert "$MAKE_TEST stub-resolve-command input='make not-existing'" "make"
assert "$MAKE_TEST stub-resolve-command input='not-existing'" ""

# eval
assert "$MAKE_TEST eval command='./script.sh'" "test-flag-root"
# TODO: make this test pass
# assert "$MAKE_TEST eval command='echo \$TEST_FLAG_ROOT'" "test-flag-root"

# env
assert_snapshot "$MAKE_TEST print-env | sed -E 's/^(MAKE_PID|MAKE_PPID|PWD|SHELL|MAKEFLAGS)=.*/\1=<redacted>/'" "make_print-env.out"

assert_snapshot "$MAKE_TEST LOGLEVEL=debug stub-core-hooks" "make_hooks.out"

# assert_raises "$MAKE_TEST self-update" 0
assert_end
