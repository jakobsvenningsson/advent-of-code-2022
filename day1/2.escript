#!/usr/bin/env escript
%% -*- erlang -*-
%%! -pa ../common/ebin
main([Input]) ->
    Res =
        lists:foldl(
          fun(Line, [H|T]) ->
                  lists:sort([max(line_sum(Line), H)|T])
          end, [0, 0, 0],
          common:input(Input, <<"\n\n">>,
                       fun(Line) ->
                               binary_to_list(Line)
                       end)),
    io:format("~p~n", [lists:sum(Res)]).

line_sum([]) ->
    0;
line_sum(Line) ->
    {Int, Rest} = string:to_integer(Line),
    Int + line_sum(string:trim(Rest)).

