-module(marketsim_simplegood).
-include("include/marketsim.hrl").

-export([supply/2, demand/2, def/0]).

def() ->
  #ms_good{name="Simple Good"}.

supply(#agent{}, #ms_good{name="Simple Good"}) ->
  1.

demand(#agent{}, #ms_good{name="Simple Good"}) ->
  1.
