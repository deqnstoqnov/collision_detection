-module( graphics ).

-behaviour( gen_server ).

%% collision API
-export([ start_link/1, add/1, delete/1, get_all_balls/0, draw/0 ,stop/0 ]).


%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record ( state, { ball_pids, ball_graphics ,canvas , h, w} ).

-define( SERVER,?MODULE).


start_link(List) -> gen_server:start_link( {local,?SERVER},?SERVER, List,[]).

add( List ) -> gen_server:call(?MODULE,{add, List } ).

delete( List ) -> gen_server:call(?MODULE,{delete , List} ).

get_all_balls() -> gen_server:call(?MODULE, get_all_balls).

draw() -> gen_server:call(?MODULE, draw ).

stop() -> gen_server:cast(?MODULE,stop).


%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init([Width,Height]) -> 
	Root = gs:start(),
	Window = gs:create(window,Root,[{bg,white },{width,Width},{height,Height},{buttonpress,true}]),
	Canvas = gs:create(canvas,Window,[{bg,white },{width,Width},{height,Height}]),	
	gs:config(Window, {map,true}),		
	{ ok, #state { canvas = Canvas, ball_pids = [],h = Height, w = Width }, 0 }.

handle_cast(stop, State) -> {stop, normal, State}.

handle_call( {add, List } , _From, State) -> 
    lists:foreach( fun(Ball)->
						BallState = gen_server:call(Ball,get_state),
						{state,VX,VY,X,Y,R,M,_} = BallState,
						G= gs:create ( image, State#state.canvas, [ {coords,[{X-R,State#state.h-Y-R}]}, {load_gif,"ball_70.gif"} ])	,
						gen_server:call(Ball,{set_state, {state,VX,VY,X,Y,R,M,G}  })
				   end, List),
	NewState = State#state{ ball_pids = lists:append(State#state.ball_pids,List) }, 
	{reply, {ok, 1}, NewState};
handle_call( {delete, List} , _From, State )-> 
	L = State#state.ball_pids,
    {_,Nok} = lists:partition( fun (X) -> lists:member(X,List) end, L),
	{reply, {ok, 1}, State#state{ ball_pids = Nok }};
handle_call( get_all_balls , _From, State )-> 
	{ reply, { ok, State#state.ball_pids } , State};
handle_call( draw , _From, State )-> 
	lists:foreach( fun(Pid)-> 
						{state,VX,VY,_,_,_,_,G}  = gen_server:call(Pid,get_state) ,
					    gs:config(G,{move,{ VX,-1*VY }})	
				   end, 
				   State#state.ball_pids
				 ),
	{ reply, { ok, State#state.ball_pids } , State}
.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

handle_info(_Info, State) -> {noreply, State}.



