#!/usr/bin/env escript
%% -*- erlang -*-
%%! -pa ../common/ebin

main([Input]) ->
    Lines = common:input(Input,
                         fun(LineBin) ->
                                Line = binary_to_list(LineBin),
                                {R1Start, [$-|Rest1]} = string:to_integer(Line),
                                {R1End, [$,|Rest2]} = string:to_integer(Rest1),
                                {R2Start, [$-|Rest3]} = string:to_integer(Rest2),
                                {R2End, []} = string:to_integer(Rest3),
                                {{R1Start, R1End}, {R2Start, R2End}}
                        end),
    Res =
        length(
          lists:filter(
            fun({R1, R2}) ->
                    is_overlap(R1, R2) orelse is_overlap(R2, R1)
            end, Lines)
         ),
    io:format("~p~n", [Res]).

is_overlap({R1Start, R1End}, {R2Start, R2End}) ->
    (R1Start >= R2Start andalso R1Start =< R2End) orelse
        (R2Start >= R1Start andalso R2Start =< R1End).
