-module(marketsim_control).

-behavior(gen_server).

-export([create_market/2]).

-export([start_link/1]).

-export([init/1, handle_call/3]).

-record(control, {supervisor}).

create_market(Name, Good) ->
  gen_server:call(?MODULE, {create_market, Name, Good}).

start_link(Supervisor) ->
  io:format("Supervisor:~p~n", [Supervisor]),
  gen_server:start_link({local, ?MODULE}, ?MODULE, Supervisor, []).

init(Supervisor) ->
  io:format("Starting control~n"),
  {ok, #control{supervisor=Supervisor}}.

handle_call({create_market, Name, Good}, _Ref, #control{supervisor=Supervisor}=State) ->
  Result = supervisor:start_child(Supervisor, marketsim_market:child_def(Name)),
  {reply, Result, State}.
