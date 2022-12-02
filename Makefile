DAYS = $(wildcard day*)

all: common/ebin/common.beam

common/ebin/common.beam: common/common.erl
	erlc -o $(@D) $^

test:
	@$(foreach DAY,$(DAYS),./test.bash $(DAY);)

clean:
	rm -f common/ebin/*

.PHONY: test clean
