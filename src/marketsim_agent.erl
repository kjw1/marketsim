-module(marketsim_agent).
-include("include/marketsim.hrl").
-behavior(gen_server).

-export([start_link/2, init/1, handle_call/3]).


start_link(DemandFunList, SupplyFunList) ->
  gen_server:start_link(?MODULE, {DemandFunList, SupplyFunList}, []).

init({DemandFunList, SupplyFunList}) ->
  {ok, #agent{demand=dict:from_list(DemandFunList), supply=dict:from_list(SupplyFunList)}}.

handle_call({get_demand, Goods}, _Ref, #agent{}=Agent)  ->
  Demand = get_demand(Goods, Agent),
  {reply, Demand, Agent}.

get_demand(Goods, Agent) ->
  get_demand(Goods, Agent, []).

get_demand([], _Agent, Demand) ->
  Demand;
get_demand([#ms_good{name=GoodName}=Good | Goods], #agent{demand=DemandFuns}=Agent, DemandList) ->
  {ok, DemandFun} = dict:find(GoodName, DemandFuns),
  GoodDemand = DemandFun(Agent, Good),
  get_demand(Goods, Agent, [{GoodName, GoodDemand} | DemandList]).

