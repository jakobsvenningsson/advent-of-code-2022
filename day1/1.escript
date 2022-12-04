#!/usr/bin/env escript
%% -*- erlang -*-
%%! -pa ../common/ebin
main([Input]) ->
    Res =
        lists:foldl(
          fun(Line, Max) ->
                  max(line_sum(Line), Max)
          end, 0, common:input(Input, <<"\n\n">>,
                               fun(Line) ->
                                       binary_to_list(Line)
                               end)),
    io:format("~p~n", [Res]).

line_sum([]) ->
    0;
line_sum(Line) ->
    {Int, Rest} = string:to_integer(Line),
    Int + line_sum(string:trim(Rest)).
