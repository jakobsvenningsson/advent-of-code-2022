#!/usr/bin/env escript
%% -*- erlang -*-
%%! -pa ../common/ebin

main([Input]) ->
    Lines = common:input(Input,
                         fun(Line) ->
                                 lists:uniq(binary_to_list(Line))
                         end),
    Res = badge_score(Lines),
    io:format("~p~n", [Res]).

badge_score([]) ->
    0;
badge_score([C1, C2, C3 | T]) ->
    C = lists:uniq(C1 ++ C2 ++ C3),
    [I] =
        C --
        ((C1 -- C2)
         ++ (C1 -- C2)
         ++ (C2 -- C1)
         ++ (C2 -- C3)
         ++ (C3 -- C1)
         ++ (C3 -- C2)),
    prio(I) + badge_score(T).

prio(Char) when Char >= $a, Char =< $z ->
    Char - 96;
prio(Char) when Char >= $A, Char =< $Z ->
    Char - 38.

