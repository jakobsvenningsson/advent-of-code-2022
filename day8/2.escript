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

solve([], _Cols, Acc) ->
    Acc;
solve([{_, Row} = RowWithIdx|Rest], Cols, Acc) ->
    solve(Rest, Cols, solve(lists:seq(1, length(Row)), RowWithIdx, Cols, Acc)).

solve([], _Row, [], Acc) ->
    Acc;
solve([Y|T], {X, Row} = RowWithIndex, [Col|Cols], Acc0) ->
    Acc = max(Acc0, view_score(Row, Y) * view_score(Col, X)),
    solve(T, RowWithIndex, Cols, Acc).

col([], _Y) ->
     [];
col([Row|Rest], Y) ->
    [lists:nth(Y, Row)|col(Rest, Y)].

view_score(_List, 0) ->
    0;
view_score(List, Idx) ->
    {Before0, After} = lists:split(Idx, List),
    Height      = lists:last(Before0),
    Before      = lists:droplast(Before0),
    BeforeScore = tree_score(lists:reverse(Before), Height),
    AfterScore  = tree_score(After, Height),
    BeforeScore * AfterScore.

tree_score(TreesInLine, FromTreeHeight) ->
    case lists:splitwith(fun(TreeHeight) -> FromTreeHeight > TreeHeight end, TreesInLine) of
        {TreesInLine, []}     -> length(TreesInLine);
        {VisibleTrees, _Rest} -> length(VisibleTrees) + 1
    end.

