-module(bigwig).
-export([start/0, stop/0]).

start() ->
    application:ensure_started([ranch, jsx, crypto, sasl, cowlib, cowboy, bigwig]).

stop() ->
    application:stop(bigwig).
