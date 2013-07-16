-module(ball).

-behaviour(gen_server).

%% collision API
-export([ start_link/1, tick/0, stop/0 ]).

-export([ get_state/0, set_state/1,set_graphics/1 ]).


%% ball ball negotiation API

-export([]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record
( state, 
  { 
  x_velocity, 
  y_velocity,  
  x_position,
  y_position,
  radius,
  mass,
  graphics
  } 
  ).
  
-define(WIDTH,1000).
-define(HEIGHT,500).  

start_link(List) -> gen_server:start( ?MODULE, List, []).

tick() -> gen_server:call(?MODULE,tick).

get_state() -> gen_server:call(?MODULE,get_state).

set_state( State ) -> get_server:call(?MODULE, {set_state,State}).

set_graphics( Picture ) -> get_server:call(?MODULE, { set_graphics, Picture }).

stop() -> gen_server:cast(?MODULE,stop).


%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init([{XVelocity,YVelocity},{XPosition,YPosition},Radius,Mass]) -> 
{ 
		ok, 
#state
		{ 
				x_velocity = XVelocity, 
				y_velocity = YVelocity, 
				x_position = XPosition, 
				y_position = YPosition,
				radius = Radius,
				mass = Mass
		}, 
		0 
}.

handle_cast(stop, State) -> {stop, normal, State}.

handle_call( tick , _From, State) -> 
X = State#state.x_position + State#state.x_velocity ,
Y = State#state.y_position + State#state.y_velocity ,
R = State#state.radius,
{NextX,NextXV} = case  (X > ?WIDTH - R orelse X < 0 + R) of 
	               true  -> {State#state.x_position-State#state.x_velocity,-1*State#state.x_velocity};
                       false -> {State#state.x_position+State#state.x_velocity,State#state.x_velocity}
                 end,
{NextY,NextYV} = case  (Y > ?HEIGHT - R orelse Y < 0 + R) of
          	       true -> {State#state.y_position-State#state.y_velocity,-1*State#state.y_velocity};
                       false-> {State#state.y_position+State#state.y_velocity,State#state.y_velocity}
                 end,
NewState = State#state
{
                x_velocity = NextXV,
		y_velocity = NextYV, 
		x_position = NextX,
		y_position = NextY
}, 
gen_event:notify(event_manager,{tick}),
{reply, {ok, 1}, NewState};
handle_call( get_state , _From, State )-> { reply, State , State};
handle_call( {set_state, NewState} , _From, _ )-> { reply, NewState , NewState};
handle_call( {set_graphics, Picture}, _From, State ) -> 
{ reply,{ok,1}, State#state{ graphics = Picture} }
.


terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

handle_info(_Info, State) -> {noreply, State}.


%%%%%%%%%%%%%%%%


