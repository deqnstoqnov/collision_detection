-module ( cycle_handler ).

-behaviour( gen_event ).

-export([add_handler/0, delete_handler/0]).
-export([init/1, handle_event/2, handle_call/2, handle_info/2, code_change/3, terminate/2]).

-import( event_manager, [ tick/0, collide/0, balls_moved/0, recalculate/0, draw/0]).

-record(state,{}).

init([]) -> {ok, #state{}}.

add_handler() -> event_handler:add_handler(?MODULE, []).

delete_handler() -> event_handler:delete_handler(?MODULE, []).

handle_event( tick, State) ->
    io:format("tick handled~n"),	
    event_manager:collide(),
	{ok, State};
handle_event(  collide , State ) ->
    io:format("collide handled~n"),	
	event_manager:balls_moved(),
	{ok, State};
handle_event(  balls_moved , State ) ->
	io:format("balls_moved handled~n"),
	event_manager:recalculate(),
	{ok, State};
handle_event(  recalculate  , State ) ->
	io:format("recalculate handled~n"),
	event_manager:draw(),
	{ok, State};
handle_event(  draw , State ) ->
	io:format("draw handled~n"),
	{ok, State}.


handle_call(_Request, State) ->  {ok,ok,State}.

handle_info(_Info, State) -> {ok, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

