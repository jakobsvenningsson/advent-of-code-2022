all: common/ebin/common.beam

common/ebin/common.beam: common/common.erl
	erlc -o $(@D) $^
