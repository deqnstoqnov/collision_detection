-module( ignite ).

-import( ball, [ start_link/1, set_state/1, get_state/0 ]).
-import( physics, [ collide/2 ]).

-compile( export_all ).

-define(OFFSET, 150).
-define(FORMATION, 3).
-define(BALL_RADIUS,35).
-define(WIDTH,1000).
-define(HEIGHT,500).
-define(MASS,2).
-define(BALLS,9).

start_balls(-1)-> [];
start_balls(N)-> 
        {ok, Pid} = ball:start_link([{random:uniform(3)-2,random:uniform(3)-2},{?OFFSET + ?OFFSET*(N rem ?FORMATION), ?OFFSET+ ?OFFSET*(N div ?FORMATION)},?BALL_RADIUS,?MASS]),
	[Pid|start_balls(N-1)].

start() ->
	
    {ok,_} = graphics:start_link([?WIDTH,?HEIGHT]),
	
	register(logger,spawn(logger,init,[[]])),
	
        event_manager:start_link(),
	gen_event:add_handler(event_manager,logger,[]),
		
	L = start_balls(9),
	graphics:add( L ),
	spawn(ignite,loop,[L]).


loop(L)->
	receive
	after 10 -> ok
	end,
	CP = [{X,Y}|| X<-L,Y<-L, X=/=Y,X<Y ],
        lists:foreach
	(
		fun ({X,Y})->
			collide(X,Y)
		end,
		CP
	),
	lists:foreach( fun(Pid)-> gen_server:call(Pid,tick)  end, L),
	graphics:draw(),	
	loop(L)
	.

