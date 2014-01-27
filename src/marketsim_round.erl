-module(marketsim_round).
-behavior(gen_fsm).

-export([start_link/4, init/1, request_supply/2, receive_supply/2]).

-record(round, {sellers, buyers, supply=[], result=in_progress, good, origin}).

start_link(Sellers, Buyers, Good, Origin) ->
  gen_fsm:start_link(?MODULE, [Sellers, Buyers, Good, Origin], []).

init([Sellers, Buyers, Good, Origin]) when is_list(Sellers), is_list(Buyers) ->
  %TODO monitor suppliers, and remove them if they die
  {ok, request_supply, #round{sellers=Sellers, buyers=Buyers, good=Good, origin=Origin}, 0}.

request_supply(timeout, #round{sellers=Sellers, good=Good}=Round) ->
  lists:foreach(fun(Seller) -> request_seller_supply(Seller, Good) end, Sellers),
  {next_state, receive_supply, Round}.

receive_supply({supply, Supply}, #round{sellers=Sellers, supply=TotalSupply}=Round) ->
  NextSupply = [Supply | TotalSupply],
  {NextState, NextStateTimeout} = continue_if_all_supply_received(Sellers, TotalSupply),
  {next_state, NextState, Round#round{supply=NextSupply}, NextStateTimeout}.

request_bids(timeout, #round{buyers=Buyers, supply=Supply, good=Good, origin=Origin}=Round) ->
  OrderedBuyers = order_buyers(Buyers),
  Result = process_orders(OrderedBuyers, Supply, Good),
  notify_origin(Origin, done),
  {next_state, done, Round#round{result=Result}}.
