-module ( logger ).

-behaviour( gen_event ).

-export([add_handler/0, delete_handler/0]).
-export([init/1, handle_event/2, handle_call/2, handle_info/2, code_change/3, terminate/2]).

-import( event_manager, [ tick/0, collide/0, balls_moved/0, recalculate/0, draw/0]).

-record(state,{ ticks, ticks_from_last_collision , collisions}).

init([]) -> {ok, #state{ ticks = 0, ticks_from_last_collision = 0, collisions = 0}}.

add_handler() -> event_handler:add_handler(?MODULE, []).

delete_handler() -> event_handler:delete_handler(?MODULE, []).

handle_event({tick}, State) ->
	print_state(State),
	{ok, State#state{ ticks = State#state.ticks+1, ticks_from_last_collision = State#state.ticks_from_last_collision+1}
};
handle_event( {collision} , State ) ->
	print_state(State),
	{ok, State#state{ collisions = State#state.collisions+1,ticks_from_last_collision = 0}}
.


handle_call(_Request, State) ->  {ok,ok,State}.

handle_info(_Info, State) -> {ok, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.


print_state(State)->
	io:format
	(
		"Ticks: ~p Ticks from last collision: ~p  Collisions: ~p~n", 
		[ State#state.ticks, State#state.ticks_from_last_collision, State#state.collisions ]	
	).
