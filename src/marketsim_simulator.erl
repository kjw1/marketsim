-module(marketsim_simulator).
-include("include/marketsim.hrl").

-export([start_link/2, init/1]).

-record(simulator, {actors, markets}).

start_link(ActorDefs, MarketDefs) ->
  gen_server:start_link(?MODULE, {ActorDefs, MarketDefs}, []).

init({ActorDefs, MarketDefs}) ->
  {ok, #simulator{}}.
