#!/usr/bin/env escript
%% -*- erlang -*-
%%! -pa ../common/ebin

-define(FS_SIZE, 70000000).

main([Input]) ->
    Data = common:input(Input,
                        <<"$">>,
                        fun(Cmd) -> binary:split(string:trim(Cmd), <<"\n">>, [global, trim_all]) end),
    ParsedData = parse_data(Data),
    UsedSize = dir_size([], ParsedData),
    FreeSize = ?FS_SIZE - UsedSize,
    NeedSize = abs(FreeSize - 30000000),
    Res =
        hd(
          lists:sort(
            lists:filtermap(
              fun(Dir) ->
                      DirSize = dir_size(Dir, ParsedData),
                      case DirSize >= NeedSize of
                          true  -> {true, DirSize};
                          false -> false
                      end
              end, maps:keys(ParsedData)))
         ),
    io:format("~p~n", [Res]).

parse_data(Data) ->
    parse_data(Data, #{}, []).

parse_data([], Acc, _Cwd) ->
    Acc;
parse_data([[<<"cd ..">>] | Rest], Acc, Cwd) ->
    parse_data(Rest, Acc, tl(Cwd));
parse_data([[<<"cd /">>] | Rest], Acc, _Cwd) ->
    parse_data(Rest, Acc, []);
parse_data([[<<"cd ", Dir/binary>>] | Rest], Acc, Cwd) ->
    parse_data(Rest, Acc, [Dir|Cwd]);
parse_data([[<<"ls">> | LsRes] | Rest], Acc, Cwd) ->
    parse_data(Rest, Acc#{Cwd => parse_ls_res(LsRes, [], Cwd)}, Cwd).

parse_ls_res([], Acc, _Cwd) ->
    Acc;
parse_ls_res([<<"dir ", Dir/binary>> | Rest], Acc, Cwd) ->
    parse_ls_res(Rest, [{dir, [Dir | Cwd]} | Acc], Cwd);
parse_ls_res([File | Rest], Acc, Cwd) ->
    {FSize, _} = string:to_integer(binary_to_list(File)),
    parse_ls_res(Rest, [{file, FSize}|Acc], Cwd).

dir_size(Dir, ParsedData) ->
    #{Dir := Files} = ParsedData,
    lists:sum(
      lists:map(fun({file, Size}) ->
                        Size;
                   ({dir, SubDir}) ->
                        dir_size(SubDir, ParsedData)
                end, Files)).



