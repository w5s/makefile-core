# Terminal colors

ifneq ($(TERM),)
	ESC          := $(shell printf '\033')
	BOLD         := $(ESC)[1m
	BLACK        := $(ESC)[30m
	RED          := $(ESC)[31m
	GREEN        := $(ESC)[32m
	YELLOW       := $(ESC)[33m
	LIGHTPURPLE  := $(ESC)[34m
	PURPLE       := $(ESC)[35m
	BLUE         := $(ESC)[36m
	WHITE        := $(ESC)[37m
	RESET        := $(ESC)[0m
	SMUL         := $(ESC)[4m
	RMUL         := $(ESC)[24m
else
	BOLD         :=
	BLACK        :=
	RED          :=
	GREEN        :=
	YELLOW       :=
	LIGHTPURPLE  :=
	PURPLE       :=
	BLUE         :=
	WHITE        :=
	RESET        :=
	SMUL         :=
	RMUL      	 :=
endif
