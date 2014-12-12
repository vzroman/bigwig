-module(bigwig_http_etsinfo).
-behaviour(cowboy_http_handler).
-export([init/3, handle/2, terminate/2]).

-compile(export_all).

init({tcp, http}, Req, _Opts) ->
    {ok, Req, undefined_state}.

handle(Req, State) ->
    Body = bigwig_working_with_html:list_to_html(etsinfo()),
    Headers = [{<<"Content-Type">>, <<"application/json">>}],
    {ok, Req2} = cowboy_http_req:reply(200, Headers, Body, Req),
    {ok, Req2, State}.

terminate(_Req, _State) ->
    ok.


etsinfo() -> [{Tab,ets:info(Tab)}||Tab<-ets:all()].
