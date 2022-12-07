-module(common).

-export([input/1]).
-export([input/2]).
-export([input/3]).

input(Path) ->
    input(Path, <<"\n">>).

input(Path, F) when is_function(F) ->
    input(Path, <<"\n">>, F);
input(Path, Delim) ->
    input(Path, Delim, fun(X) -> X end).

input(Path, Delim, F) ->
    {ok, Data} = file:read_file(Path),
    Lines = binary:split(Data, Delim, [global, trim_all]),
    lists:filtermap(fun(Line) ->
                            case F(Line) of
                                {true, _} = Res ->
                                    Res;
                                false ->
                                    false;
                                Res ->
                                    {true, Res}
                            end
                    end, Lines).
