#!/usr/bin/env escript
%% -*- erlang -*-
%%! -pa ../common/ebin

main([Input]) ->
    Rows = common:input(Input,
                        <<"\n">>,
                        fun(Line) -> binary_to_list(Line) end),
    Cols = [col(Rows, Y) || Y <- lists:seq(1, length(Rows))],
    Res = solve(Rows, Cols),
    io:format("~p~n", [Res]).

solve(Rows, Cols) ->
    solve(lists:enumerate(Rows), Cols, _Acc = 0).

solve([{1, Row}|Rest], Cols, Acc) ->
    solve(Rest, Cols, Acc + length(Row));
solve([{_, Row}], _Cols, Acc) ->
    Acc + length(Row);
solve([{_, Row} = RowWithIdx|Rest], Cols, Acc) ->
    solve(Rest, Cols, solve_row(lists:enumerate(Row), RowWithIdx, Cols, Acc)).

solve_row([{1, _}|T], Row, [_|Cols], Acc) ->
    solve_row(T, Row, Cols, Acc + 1);
solve_row([_], _Row, [_], Acc) ->
    Acc + 1;
solve_row([{Y, Height}|T], {X, Row} = RowWithIndex, [Col|Cols], Acc0) ->
    Acc =
        case is_visible(Row, Y, Height) orelse is_visible(Col, X, Height) of
            true  -> Acc0 + 1;
            false -> Acc0
        end,
    solve_row(T, RowWithIndex, Cols, Acc).

col([], _Y) ->
     [];
col([Row|Rest], Y) ->
    [lists:nth(Y, Row)|col(Rest, Y)].

is_visible(List, Idx, Height) ->
    {Before0, After} = lists:split(Idx, List),
    Before = lists:droplast(Before0),
    Height > lists:max(Before) orelse Height > lists:max(After).
