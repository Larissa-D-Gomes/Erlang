-module(message).
-export([start/0,process/0]).

start() ->
    spawn(message, process, []).

process() ->
    receive
        oi ->
           io:fwrite("ola!\n")
    end.