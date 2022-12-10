#!/usr/bin/env escript
%% -*- erlang -*-
%%! -pa ../common/ebin

main([Input]) ->
    Cmds = common:input(Input,
                        <<"\n">>,
                        fun(<<"noop">>) ->
                                noop;
                           (<<"addx ", N/binary>>) ->
                                {addx, binary_to_integer(N), 1}
                        end),
    Res = process_cmds(Cmds),
    io:format("~p~n", [Res]).

process_cmds(Cmds) ->
    process_cmds(Cmds, _Cycle = 1, _X = 1, _Acc = 0).

process_cmds([], _Cycle, _X, Acc) ->
    Acc;
process_cmds([noop|T], Cycle, X, Acc0) ->
    Acc = maybe_update_acc(Cycle, X, Acc0),
    process_cmds(T, Cycle + 1, X, Acc);
process_cmds([{addx, N, 0}|T], Cycle, X, Acc0) ->
    Acc = maybe_update_acc(Cycle, X, Acc0),
    process_cmds(T, Cycle + 1, X + N, Acc);
process_cmds([{addx, N, R}|T], Cycle, X, Acc0) ->
    Acc = maybe_update_acc(Cycle, X, Acc0),
    process_cmds([{addx, N, R - 1}|T], Cycle + 1, X, Acc).

maybe_update_acc(Cycle, X, Acc) ->
    case Cycle rem 40 of
        20 -> Acc + (X * Cycle);
        _  -> Acc
    end.
