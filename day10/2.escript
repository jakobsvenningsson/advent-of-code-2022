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
    ok = process_cmds(Cmds).

process_cmds(Cmds) ->
    process_cmds(Cmds, _Cycle = 0, _X = 1).

process_cmds([], _Cycle, _X) ->
    ok;
process_cmds([noop|T], Cycle, X) ->
    draw(Cycle, X),
    process_cmds(T, Cycle + 1, X);
process_cmds([{addx, N, 0}|T], Cycle, X) ->
    draw(Cycle, X),
    process_cmds(T, Cycle + 1, X + N);
process_cmds([{addx, N, R}|T], Cycle, X) ->
    draw(Cycle, X),
    process_cmds([{addx, N, R - 1}|T], Cycle + 1, X).

draw(Cycle, X) ->
    RowPos = Cycle rem 40,
    case RowPos of
        0 when Cycle =/= 0 ->
            io:format("~n", []);
        _ ->
            ok
    end,
    case abs(RowPos - X) =< 1 of
        true ->
            io:format("#");
        false ->
            io:format(".")
    end.

