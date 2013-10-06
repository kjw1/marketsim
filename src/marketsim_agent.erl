-module(marketsim_agent).
-behavior(gen_server).

-export([start_link/0, init/1]).

-record(agent, {funds=0, goods=0}).

start_link() ->
  gen_server:start_link(?MODULE, [], []).

init([]) ->
  {ok, #agent{}}.
