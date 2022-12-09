#!/usr/bin/env escript
%% -*- erlang -*-
%%! -pa ../common/ebin

main([Input]) ->
    Moves = common:input(Input,
                         <<"\n">>,
                         fun(Line) ->
                                 [Direction, Steps] = binary:split(Line, <<" ">>),
                                 {direction(Direction), binary_to_integer(Steps)}

                         end),
    Origo = {0, 0},
    Res = solve(Moves,
                _TailList = lists:duplicate(9, Origo),
                _HeadPos = Origo,
                _Visited = sets:from_list([Origo], [{version, 2}])),
    io:format("~p~n", [Res]).

direction(<<"R">>) ->
    right;
direction(<<"L">>) ->
    left;
direction(<<"U">>) ->
    up;
direction(<<"D">>) ->
    down.

solve([], _TailList, _HeadPos, Visited) ->
    sets:size(Visited);
solve([Move|Moves], TailList0, HeadPos0, Visited0) ->
    {TailList, HeadPos, Visited} = make_move(Move, TailList0, HeadPos0, Visited0),
    solve(Moves, TailList, HeadPos, Visited).

make_move({_Direction, 0}, TailList, HeadPos, Visited) ->
    {TailList, HeadPos, Visited};
make_move({Direction, Steps}, TailList, HeadPos, Visited) ->
    NewHeadPos = move_head(HeadPos, Direction),
    {NewTailList, _} =
        lists:mapfoldl(fun(TailElem, Next) ->
                              NewPos = move_tail(TailElem, Next),
                              {NewPos, NewPos}
                      end, NewHeadPos, TailList),
    make_move({Direction, Steps - 1}, NewTailList, NewHeadPos,
              sets:add_element(lists:last(NewTailList), Visited)).

move_head({X, Y}, up) ->
    {X, Y + 1};
move_head({X, Y}, down) ->
    {X, Y - 1};
move_head({X, Y}, left) ->
    {X - 1, Y};
move_head({X, Y}, right) ->
    {X + 1, Y}.

move_tail(Pos, Pos) ->
    Pos;
move_tail({X1, Y1} = TailPos, {X2, Y2} = HeadPos) ->
    case abs(X2 - X1) =< 1 andalso abs(Y2 - Y1) =< 1 of
        true ->
            TailPos;
        false ->
            do_move_tail(TailPos, HeadPos)
    end.

do_move_tail({X1, Y1} = _TailPos, {X2, Y2} = _HeadPos) ->
    {X1 + step(X1, X2), Y1 + step(Y1, Y2)}.

step(X, X) ->
    0;
step(X1, X2) when X1 > X2 ->
    -1;
step(X1, X2) when X2 > X1 ->
    1.
