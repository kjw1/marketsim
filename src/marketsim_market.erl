-module(marketsim_market).

-behavior(gen_server).
-include("include/marketsim.hrl").

-export([child_def/2]).
-export([start_link/2]).
-export([init/1, handle_cast/2]).

-record(market, {name, time=0, good}).

child_def(Name, Good) ->
  {{market, Name}, {?MODULE, start_link, [Name, Good]}, transient, 10000, worker, [?MODULE]}.

start_link(Name, Good) ->
  gen_server:start_link(?MODULE, [Name, Good], []).

init([Name, #ms_good{name=GoodName}=Good]) ->
  gproc:add_global_name({market, GoodName}),
  {ok, #market{name=Name, good=Good}}.

handle_cast(tick, #market{time=Time}=State) ->
  {noreply, State#market{time=Time + 1}}.

