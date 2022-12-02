-module(common).

-export([input/1]).
-export([input/2]).

input(Path) ->
    input(Path, fun(X) -> X end).

input(Path, F) ->
    {ok, Data} = file:read_file(Path),
    Lines = string:split(string:trim(Data), <<"\n">>, all),
    lists:map(F, Lines).
