#!/usr/bin/env escript
%% -*- erlang -*-
%%! -pa ../common/ebin

main([Input]) ->
    [Data] = common:input(Input,
                          <<"\n">>),
    Res = find_start_of_packet(Data, 0),
    io:format("~p~n", [Res]).

find_start_of_packet(<<S:4/binary, Rest/binary>>, I) ->
    Group = binary_to_list(S),
    case lists:uniq(Group) of
        Group ->
            I + 4;
        _     ->
            NewS = list_to_binary(tl(Group)),
            find_start_of_packet(<<NewS/binary, Rest/binary>>, I + 1)
    end.
