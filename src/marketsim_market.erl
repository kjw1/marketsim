-module(marketsim_market).

-behavior(gen_server).

-export([child_def/1]).
-export([start_link/1]).
-export([init/1, handle_cast/2]).

-record(market, {name, time=0}).

child_def(Name) ->
  {{market, Name}, {?MODULE, start_link, [Name]}, transient, 10000, worker, [?MODULE]}.

start_link(Name) ->
  gen_server:start_link(?MODULE, [Name], []).

init(Name) ->
  {ok, #market{name=Name}}.

handle_cast(tick, #market{time=Time}=State) ->
  {noreply, State#market{time=Time + 1}}.

