DAYS = $(wildcard day*)

all: build test

build: common/ebin/common.beam

common/ebin/common.beam: common/common.erl
	erlc -o $(@D) $^

test-day%:
	@./test.bash $*

test:
	@$(foreach DAY,$(DAYS:day%=%),./test.bash $(DAY);)

clean:
	rm -f common/ebin/*

.PHONY: test clean
