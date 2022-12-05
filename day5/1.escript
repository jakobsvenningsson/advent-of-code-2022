#!/usr/bin/env escript
%% -*- erlang -*-
%%! -pa ../common/ebin

main([Input]) ->
    [Piles0, Moves0] = common:input(Input,
                                    <<"\n\n">>,
                                    fun(Line0) ->
                                            binary:split(Line0, <<"\n">>, [global, trim])
                                    end),
    Piles    = parse_piles(Piles0),
    Moves    = [parse_move(Move) || Move <- Moves0],
    NewPiles = make_moves(Moves, Piles),
    io:format("~s~n", [make_res_str(NewPiles)]).

parse_piles(Piles0) ->
    [Idxes0 | Rest] = lists:reverse(Piles0),
    Idxes = binary:split(Idxes0, <<" ">>, [global, trim_all]),
    Piles =  maps:from_keys([binary_to_integer(Idx) || Idx <- Idxes], []),
    parse_piles(Piles, Rest).

parse_piles(Piles, []) ->
    Piles;
parse_piles(Piles0, [Row | Rest]) ->
    Piles = parse_row(Row, Piles0),
    parse_piles(Piles, Rest).

parse_row(Row, Piles) ->
    parse_row(Row, 1, Piles).

parse_row(<<>>, _PileIdx, Piles) ->
    Piles;
parse_row(<<" [", Rest/binary>>, PileIdx, Piles) ->
    parse_row(<<"[", Rest/binary>>, PileIdx, Piles);
parse_row(<<"[", C:1/binary, "]", Rest/binary>>, PileIdx, Piles0)
  when C >= <<"A">>, C =< <<"Z">> ->
    Piles = maps:update_with(PileIdx, fun(Pile) -> [C | Pile] end, Piles0),
    parse_row(Rest, PileIdx + 1, Piles);
parse_row(<<"    ", Rest/binary>>, PileIdx, Piles) ->
    parse_row(Rest, PileIdx + 1, Piles).

parse_move(<<"move ", RestBin/binary>>) ->
    Rest0 = binary_to_list(RestBin),
    {N, [$ , $f, $r, $o, $m, $  | Rest]} = string:to_integer(Rest0),
    {From, [$ , $t, $o, $  | Rest1]} = string:to_integer(Rest),
    {To, []} = string:to_integer(Rest1),
    {N, From, To}.

make_moves([], Piles) ->
    Piles;
make_moves([{N, From, To} | Rest], Piles) ->
    Pile               = maps:get(From, Piles),
    {Crates, RestPile} = lists:split(N, Pile),
    NewPiles0          = maps:update_with(To, fun(S) ->
                                                  lists:reverse(Crates) ++ S
                                          end, Piles),
    NewPiles           = maps:update(From, RestPile, NewPiles0),
    make_moves(Rest, NewPiles).

make_res_str(Piles) ->
    lists:map(
      fun(K) ->
              case maps:get(K, Piles) of
                  [] -> [];
                  [H | _T] -> H
              end
      end, lists:seq(1, maps:size(Piles))).


