#!/usr/bin/env escript
%% -*- erlang -*-
%%! -pa ../common/ebin
main(_Args) ->
    {_, Max} =
        lists:foldl(
          fun(<<"">>, {Acc, Max}) when Acc > Max ->
                  {0, Acc};
             (<<"">>, {_Acc, Max}) ->
                  {0, Max};
             (Line, {Acc, Max}) ->
                  {Acc + binary_to_integer(Line), Max}
          end, {0, 0}, common:input("input.txt")),
    io:format("~p~n", [Max]).
