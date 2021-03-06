%%%-------------------------------------------------------------------
%%% @hidden
%%% @author Fernando Benavides <fernando.benavides@inakanetworks.com>
%%% @copyright (C) 2010 Fernando Benavides <fernando.benavides@inakanetworks.com>
%%% @doc apns4erl main supervisor
%%% @end
%%%-------------------------------------------------------------------
-module(apns_sup).
-author('Fernando Benavides <fernando.benavides@inakanetworks.com>').

-behaviour(supervisor).

-include("apns.hrl").

-export([start_link/0, start_connection/2, start_connection/3]).
-export([init/1]).

%% ===================================================================
%% API functions
%% ===================================================================
%% @hidden
-spec start_link() -> {ok, pid()} | ignore | {error, {already_started, pid()} | shutdown | term()}.
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% @hidden
-spec start_connection(#apns_connection{}, undefined | pid()) -> {ok, pid()} | {error, term()}.
start_connection(Connection, Owner) ->
  supervisor:start_child(?MODULE, [Connection, Owner]).

%% @hidden
-spec start_connection(atom(), #apns_connection{}, undefined | pid()) -> {ok, pid()} | {error, term()}.
start_connection(Name, Connection, Owner) ->
  supervisor:start_child(?MODULE, [Name, Connection, Owner]).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================
%% @hidden
-spec init(_) ->  {ok, {{simple_one_for_one, 0, 1}, [{connection, {apns_connection, start_link, []}, temporary, 5000, worker, [apns_connection]}]}}.
init(_) ->
  {ok,
   {{simple_one_for_one, 0, 1},
    [{connection, {apns_connection, start_link, []},
      temporary, 5000, worker, [apns_connection]}]}}.
