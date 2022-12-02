#!/usr/bin/env escript
%% -*- erlang -*-
%%! -pa ../common/ebin
main(_Args) ->
    {_, Res} =
        lists:foldl(
          fun(<<"">>, {Acc, [H|T] = _Max}) when Acc > H ->
                  {0, lists:sort([Acc|T])};
             (<<"">>, {_Acc, Max}) ->
                  {0, Max};
             (Line, {Acc, Max}) ->
                  {Acc + binary_to_integer(Line), Max}
          end, {0, [0, 0, 0]}, common:input("input.txt")),
    io:format("~p~n", [lists:sum(Res)]).
