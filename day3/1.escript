#!/usr/bin/env escript
%% -*- erlang -*-
%%! -pa ../common/ebin

main([Input]) ->
    Lines = common:input(Input,
                        fun(Line) ->
                                binary_to_list(Line)
                        end),
    Res =
        lists:foldl(
          fun(Line, Acc) ->
                  {S10, S20}  = lists:split(round(length(Line) / 2), Line),
                  [S, S1, S2] = [lists:uniq(L) || L <- [Line, S10, S20]],
                  Intersection = S -- ((S1 -- S2) ++ (S2 -- S1)),
                  lists:sum([prio(I) || I <- Intersection]) + Acc
          end, 0, Lines),
    io:format("~p~n", [Res]).

prio(Char) when Char >= $a, Char =< $z ->
    Char - 96;
prio(Char) when Char >= $A, Char =< $Z ->
    Char - 38.

