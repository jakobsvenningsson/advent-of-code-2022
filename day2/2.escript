#!/usr/bin/env escript
%% -*- erlang -*-
%%! -pa ../common/ebin

-define(ROCK,    <<"X">>).
-define(PAPER,   <<"Y">>).
-define(SCISSOR, <<"Z">>).

-define(LOSE, <<"X">>).
-define(DRAW, <<"Y">>).
-define(WIN,  <<"Z">>).

main([Input]) ->
    Lines =
        common:input(
          Input,
          fun(<<A:1/binary, " ", B:1/binary>>) ->
                  {true, {conv(A), B}}
          end),
    Res =
        lists:foldl(
          fun({A, Result}, Acc) ->
                  B = choice(A, Result),
                  Acc + win_point(A, B) + select_point(B)
          end, 0, Lines),
    io:format("~p~n", [Res]).

conv(<<"A">>) -> ?ROCK;
conv(<<"B">>) -> ?PAPER;
conv(<<"C">>) -> ?SCISSOR.

select_point(?ROCK)    -> 1;
select_point(?PAPER)   -> 2;
select_point(?SCISSOR) -> 3.

win_point(A, A)             -> 3;
win_point(?ROCK, ?PAPER)    -> 6;
win_point(?ROCK, ?SCISSOR)  -> 0;
win_point(?PAPER, ?ROCK)    -> 0;
win_point(?PAPER, ?SCISSOR) -> 6;
win_point(?SCISSOR, ?ROCK)  -> 6;
win_point(?SCISSOR, ?PAPER) -> 0.

choice(A, ?DRAW)        -> A;
choice(?ROCK, ?LOSE)    -> ?SCISSOR;
choice(?ROCK, ?WIN)     -> ?PAPER;
choice(?PAPER, ?LOSE)   -> ?ROCK;
choice(?PAPER, ?WIN)    -> ?SCISSOR;
choice(?SCISSOR, ?LOSE) -> ?PAPER;
choice(?SCISSOR, ?WIN)  -> ?ROCK.
